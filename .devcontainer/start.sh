#!/bin/bash
# g2ray start script — keepalive: 50s self-ping
tmux kill-session -t g2ray 2>/dev/null || true
tmux new-session -d -s g2ray
tmux send-keys -t g2ray "sudo /usr/local/bin/xray run -c /etc/xray/g2ray.json &>/tmp/xray.log" Enter
sleep 2

# Self-ping keepalive — hit the Codespace's own public URL every 50s.
# Outbound pings (e.g. github.com) do NOT reset the Codespace idle timer;
# only incoming requests on a forwarded port do.
SELF_URL="https://${CODESPACE_NAME}-443.app.github.dev"
tmux new-window -t g2ray -n keepalive
tmux send-keys -t g2ray:keepalive "while true; do curl -sk --max-time 10 '${SELF_URL}/' -o /dev/null; sleep 50; done" Enter
echo "[g2ray] Keepalive فعال است — هر 50 ثانیه self-ping به ${SELF_URL}"
echo "[g2ray] سرور داخل tmux اجرا شد"
echo "[g2ray] برای دیدن log: tmux attach -t g2ray"
