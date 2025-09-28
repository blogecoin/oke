# Daily Logs Setup Instructions

## 🎯 Tình trạng hiện tại

✅ **Đã hoàn thành:**
- Tạo thư mục `daily-logs`
- Khởi tạo Git repository
- Cấu hình Git với user: `duyentinh188 <duyentinh188@gmail.com>`
- Tạo file `log.txt`
- Viết script `daily_commit.py`
- Thêm remote origin: `git@github.com:duyentinh188/daily-logs.git`
- Thực hiện commit đầu tiên (local)

❌ **Cần hoàn thành:**
- Push lên GitHub (cần SSH key)
- Thiết lập cron job/scheduled task

## 🔑 Thiết lập SSH Key cho GitHub

**Bước 1: Tạo SSH key (nếu chưa có)**
```bash
ssh-keygen -t rsa -b 4096 -C "duyentinh188@gmail.com"
```

**Bước 2: Copy SSH public key**
```bash
cat ~/.ssh/id_rsa.pub
```

**Bước 3: Thêm SSH key vào GitHub**
1. Vào GitHub → Settings → SSH and GPG keys
2. Click "New SSH key"
3. Paste nội dung từ bước 2
4. Save

**Bước 4: Test SSH connection**
```bash
ssh -T git@github.com
```

**Bước 5: Push lên GitHub**
```bash
cd "C:\Users\duyen\Desktop\SCR_GITHUP\daily-logs"
git push -u origin main
```

## ⏰ Thiết lập Cron Job (Windows)

**Chạy script setup:**
```bash
cd "C:\Users\duyen\Desktop\SCR_GITHUP\daily-logs"
python cron_job_setup.py
```

**Hoặc thiết lập thủ công:**
1. Mở Task Scheduler
2. Create Basic Task
3. Name: "Daily Logs Commit"
4. Trigger: Daily at 00:00
5. Action: Start a program
6. Program: `python`
7. Arguments: `"C:\Users\duyen\Desktop\SCR_GITHUP\daily-logs\daily_commit.py"`

## 🧪 Test Script

**Test thủ công:**
```bash
cd "C:\Users\duyen\Desktop\SCR_GITHUP\daily-logs"
python daily_commit.py
```

## 📁 Files trong dự án

- `log.txt` - File chứa logs hàng ngày
- `daily_commit.py` - Script chính
- `cron_job_setup.py` - Script thiết lập scheduled task
- `setup_instructions.md` - Hướng dẫn này

## 🎯 Mục tiêu

Script sẽ tự động chạy mỗi ngày lúc 00:00 UTC và:
1. Ghi thêm dòng "Update at [UTC datetime]" vào `log.txt`
2. Chạy `git add log.txt`
3. Commit với message "update <datetime>"
4. Push lên `origin main`