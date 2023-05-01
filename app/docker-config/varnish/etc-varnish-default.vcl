vcl 4.0;

import std;
import purge;

### Start configuring backends ###

backend localhost {
  .host = "localhost";
  .host_header = "localhost";
  .port = "80";
  .connect_timeout = 360s;
  .first_byte_timeout = 360s;
  .between_bytes_timeout = 360s;
}

### End configuring backends ###

### Start configuring recv ###
sub vcl_recv {
    # Happens before we check if we have this in cache already.
    #
    # Typically you clean up the request here, removing cookies you don't need,
    # rewriting the request, etc.

    # Set x-forwarded-for header
    if (req.http.x-forwarded-for) {
      set req.http.X-Forwarded-For = req.http.X-Forwarded-For + ", " + client.ip;
    } else {
      set req.http.X-Forwarded-For = client.ip;
    }
    if (req.method == "GET" && req.url == "/varnish-status") {
        return(synth(200, "OK"));
    }

    # Only allow PURGE requests from IP addresses in the 'purge_authorized' ACL.
    if (req.method == "PURGE") {
        if (client.ip !~ purge_authorized) {
            return (synth(405));
        }
        return (hash);
    }

    # Only allow BAN requests from IP addresses in the 'purge' ACL.
    if (req.method == "BAN") {
        # Check the purge_authorized acl for authorized IP's.
        if (!client.ip ~ purge_authorized) {
            return (synth(403, "Not allowed."));
        }
        # Use the Purge-Cache-Tags header.
        # Tried using Cache-Tags but it just wouldn't work.
        # For Drupal, install purge_purger_http_tagsheader module.
        if (req.http.Purge-Cache-Tags) {
            ban("obj.http.Purge-Cache-Tags ~ " + req.http.Purge-Cache-Tags);
        } elif (req.http.Cache-Tags) {
            ban("obj.http.Cache-Tags ~ " + req.http.Cache-Tags);
        }
        else {
            return (synth(403, "Purge-Cache-Tags or Cache-Tags header is missing."));
        }
        # Throw a synthetic page so the request won't go to the backend.
        return (synth(200, "Ban added."));
    }

    # We only have 1 backend, so use it.
    set req.backend_hint = localhost;

    # Only cache GET and HEAD requests (pass through POST requests).
    if (req.method == "POST") {
        return (pass);
    }

    # If backends are down, use anonymous, cached pages
    if (!std.healthy(req.backend_hint)){
         unset req.http.Cookie;
    }

    if (
         req.url ~ "^/status\.php$" ||
         req.url ~ "^/update\.php$" ||
         req.url ~ "^/install\.php$" ||
         req.url ~ "^/admin$" ||
         req.url ~ "^/admin/.*$" ||
         req.url ~ "^/entity_reference_autocomplete/.*$" ||
         (req.url ~ "^/user/.*/edit/.*$") ||
         req.url ~ "^/users/.*$" ||
         req.url ~ "^/info/.*$" ||
         req.url ~ "^/flag/.*$" ||
         req.url ~ "^.*/ajax/.*$" ||
         req.url ~ "^/manual-login$" ||
         req.url ~ "^/manual-login.*$" ||
         req.url ~ "^.*/ahah/.*$"
    ) {
        return (pass);
    }

    if (req.http.Cookie) {
        # removing these styling and photo cookies from here will allow it to be cached
        if (req.url !~ "webform" && req.url ~ "(?i)\.(htm|html|pdf|asc|dat|txt|doc|xls|ppt|tgz|csv|png|gif|jpeg|jpg|ico|swf|css|js)(\?.*)?$") {
            unset req.http.Cookie;
        }
        set req.http.Cookie = ";" + req.http.Cookie;
        set req.http.Cookie = regsuball(req.http.Cookie, "; +", ";");
        set req.http.Cookie = regsuball(req.http.Cookie, ";(SESS[a-z0-9]+|SSESS[a-z0-9]+|NO_CACHE)=", "; \1=");
        set req.http.Cookie = regsuball(req.http.Cookie, ";[^ ][^;]*", "");
        set req.http.Cookie = regsuball(req.http.Cookie, "^[; ]+|[; ]+$", "");
        if (req.http.Cookie == "") {
            # If there are no remaining cookies, remove the cookie header. If there
            # aren't any cookie headers, Varnish's default behavior will be to cache
            # the page.
            unset req.http.Cookie;
        }
        else {
            # If there is any cookies left (a session or NO_CACHE cookie), do not
            # cache the page. Pass it on to the backend directly.
            return (pass);
        }
    }
}
### End configuring recv ###

### Start configuring backend_response ###
sub vcl_backend_response {
    # Happens after we have read the response headers from the backend.
    #
    # Here you clean the response headers, removing silly Set-Cookie headers
    # and other mistakes your backend does.

    # Set ban-lurker friendly custom headers.
    set beresp.http.X-Url = bereq.url;
    set beresp.http.X-Host = bereq.http.host;

    # Cache 404s, 301s, at 500s with a short lifetime to protect the backend.
    if (beresp.status == 404 || beresp.status == 301 || beresp.status == 500) {
        set beresp.ttl = 1m;
    }

    # Enable streaming directly to backend for BigPipe responses.
    if (beresp.http.Surrogate-Control ~ "BigPipe/1.0") {
        set beresp.do_stream = true;
        set beresp.ttl = 0s;
    }

    # Don't allow static files to set cookies.
    # (?i) denotes case insensitive in PCRE (perl compatible regular expressions).
    # This list of extensions appears twice, once here and again in vcl_recv so
    # make sure you edit both and keep them equal.
    if (bereq.url ~ "(?i)\.(htm|html|pdf|asc|dat|txt|doc|xls|ppt|tgz|csv|png|gif|jpeg|jpg|ico|swf|css|js)(\?.*)?$") {
        unset beresp.http.set-cookie;
    }
    else if (beresp.status == 404) {
        set beresp.ttl = 60m;
    }
    else {
        set beresp.ttl = 5m;
    }

    # Allow items to be stale if needed.
    set beresp.grace = 12h;
}
### End configuring backend_response ###

### Start configuring deliver ###
sub vcl_deliver {
    # Happens when we have all the pieces we need, and are about to send the
    # response to the client.
    #
    # You can do accounting or modifying the final object here.

    # Remove headers that clients need not see.
    unset resp.http.X-Url;
    unset resp.http.X-Host;
    unset resp.http.Purge-Cache-Tags;
    unset resp.http.Cache-Tags;
    unset resp.http.X-Generator;
    unset resp.http.X-Drupal-Dynamic-Cache;
    unset resp.http.X-Drupal-Cache;
    unset resp.http.Server;

    # The value drupal sets for this is often used for fingerprinting:
    set resp.http.Expires = "Mon, 19 October 1964 00:00:00 GMT";

    # Set a header to try and force most recent rendering mode for IE
    set resp.http.X-UA-Compatible = "IE=Edge,chrome=1";

    # Configure Cache-Control headers
    if (req.url ~ "(?i)\.(htm|html|pdf|asc|dat|txt|doc|xls|ppt|tgz|csv|png|gif|jpeg|jpg|ico|swf)$"){
        set resp.http.Cache-Control = "max-age=2678400, private";
    }
    elif (req.url ~ "(?i)\.(css|js)$") {
        set resp.http.Cache-Control = "max-age=1200, private";
    }
    else {
        set resp.http.Cache-Control = "max-age=150, private";
    }
    # Tell the client if the Varnish was hit or missed.
    if (obj.hits > 0) {
        set resp.http.X-Varnish-Cache = "HIT";
    }
    else {
        set resp.http.X-Varnish-Cache = "MISS";
    }

    # Set some headers for fun and utility.
    set resp.http.X-Powered-By = "Caffeinated Water and Sheer Willpower 3.0";
}
### End configuring deliver ###

### Start configuring extra blocks ###
# Access control list for PURGE requests.
acl purge_authorized {
  "127.0.0.1";
  "172.0.0.0"/8;
}
### End configuring extra blocks ###