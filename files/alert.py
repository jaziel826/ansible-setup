import sys
import requests

def send_alert(data, title, priority, tags):
    url = "https://ntfy.digecloud.work/Ansible"
    headers = {
        "Title": title,
        "Priority": priority,
        "Tags": tags
    }
    response = requests.post(url, data=data, headers=headers)
    
    if response.status_code == 200:
        print(0)
    else:
        print("Failed to send alert.")

def main():
    if len(sys.argv) != 5:
        print("Usage: python alert_script.py <data> <title> <priority> <tags>")
        return
    
    data = sys.argv[1]
    title = sys.argv[2]
    priority = sys.argv[3]
    tags = sys.argv[4]
    
    send_alert(data, title, priority, tags)

if __name__ == "__main__":
    main()
