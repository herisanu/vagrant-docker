push_foobar:
    file.managed:
        - name: /etc/foobar
        - source: salt://foobar
        - user: root
        - group: root
        - mode: 4777
