redis:
    pkg.installed:
        - name: redis
    service.running:
        - name: redis
        - watch:
            - file: /etc/redis.conf

copy_redis_conf:
    file.managed:
        - name: /etc/redis.conf
        - source: salt://redis/redis.conf
