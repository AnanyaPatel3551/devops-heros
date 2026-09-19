### Ingress :-
 - Is it a set of rules that by which kubernetes distribute the traffic ( basically which traffic should reach  to which service).
 - It is also a single entry point for multiple services.

 - Without it , each service may need it's own multiple services.
 - ***Ingress can route based on PATH :***
     - host
     - path


### Ingress_Controller :-
 - It is the actuall component that watches Ingress resources and implement the routing rules.
 - Ex - NGINX Ingress Controller, Traefik , HAProxy
 
