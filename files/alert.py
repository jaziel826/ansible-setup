import sys
import requests

PUSHOVER_API_URL = "https://api.pushover.net/1/messages.json"

def send_alert(
    message,
    title,
    priority,
    user_key,
    app_token,
    device
):
    payload = {
        "token": app_token,
        "user": user_key,
        "message": message,
        "title": title,
        "priority": priority,
        "device": device
    }

    response = requests.post(PUSHOVER_API_URL, data=payload, timeout=10)

    if response.status_code == 200:
        print(0)
    else:
        print(f"Failed to send alert: {response.status_code} {response.text}")
        sys.exit(1)

def main():
    if len(sys.argv) != 7:
        print(
            "Usage: python alert.py "
            "<message> <title> <priority> "
            "<user_key> <app_token> <device>"
        )
        sys.exit(1)

    message = sys.argv[1]
    title = sys.argv[2]
    priority = sys.argv[3]
    user_key = sys.argv[4]
    app_token = sys.argv[5]
    device = sys.argv[6]

    send_alert(
        message,
        title,
        priority,
        user_key,
        app_token,
        device
    )

if __name__ == "__main__":
    main()
