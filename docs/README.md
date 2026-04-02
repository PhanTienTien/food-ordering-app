# 🍔 Food Ordering App

## 📖 Giới thiệu
Ứng dụng đặt đồ ăn cho phép người dùng tìm kiếm món ăn, đặt hàng và theo dõi trạng thái đơn hàng. Hệ thống hỗ trợ nhiều vai trò gồm **Admin**, **Customer** và **Staff** với các chức năng riêng biệt.

---

# 🧩 MÔ TẢ CHỨC NĂNG

---

## 👨‍💼 1. ADMIN

### 1.1. Quản lý Thực thể (Merchant & User Management)
**Mô tả:**  
Admin quản lý toàn bộ các thực thể trong hệ thống: quán ăn (Merchant), nhân viên (Staff) và khách hàng (Customer).

**Chức năng:**
- Duyệt đăng ký quán mới (Merchant Approval)
- Khóa / mở khóa tài khoản quán
- Tạo và phân quyền tài khoản Staff
- Xem danh sách khách hàng và lịch sử giao dịch
- Khóa tài khoản khách hàng vi phạm

---

### 1.2. Quản lý Danh mục & Nội dung (Master Data)
**Mô tả:**  
Quản lý dữ liệu dùng chung đảm bảo tính thống nhất hệ thống.

**Chức năng:**
- Tạo / chỉnh sửa / xoá danh mục món ăn
- Kiểm duyệt thông tin món ăn (tên, giá, hình ảnh)
- Ẩn hoặc xoá nội dung không phù hợp
- Quản lý đánh giá từ khách hàng

---

### 1.3. Cấu hình Kinh doanh & Tài chính
**Mô tả:**  
Thiết lập các quy tắc tài chính và vận hành.

**Chức năng:**
- Cấu hình phần trăm chiết khấu (commission)
- Quản lý doanh thu hệ thống
- Tính toán thanh toán cho Merchant (payout)
- Thiết lập phí giao hàng

---

### 1.4. Vận hành & Marketing
**Mô tả:**  
Triển khai hoạt động quảng bá và điều hành hệ thống.

**Chức năng:**
- Tạo mã giảm giá (voucher)
- Quản lý banner quảng cáo
- Gửi thông báo hàng loạt
- Theo dõi & xử lý tranh chấp đơn hàng

---

### 1.5. Báo cáo & Phân tích
**Mô tả:**  
Theo dõi hiệu suất hoạt động của hệ thống.

**Chức năng:**
- Dashboard tổng quan (doanh thu, đơn hàng)
- Thống kê theo ngày / tháng / năm
- Xếp hạng quán ăn và món ăn

---

## 👤 2. KHÁCH HÀNG (CUSTOMER)

### 2.1. Tìm kiếm & Khám phá
**Mô tả:**  
Người dùng tìm kiếm và khám phá món ăn.

**Chức năng:**
- Xác định vị trí (GPS)
- Tìm kiếm theo tên món / quán
- Lọc theo:
    - Khoảng cách
    - Giá
    - Đánh giá
    - Khuyến mãi
- Duyệt theo danh mục

---

### 2.2. Đặt hàng
**Mô tả:**  
Cho phép lựa chọn và đặt món.

**Chức năng:**
- Xem chi tiết món
- Tùy chỉnh món (size, topping, ghi chú)
- Thêm vào giỏ hàng
- Tính tổng tiền (bao gồm phí ship)
- Áp dụng voucher
- Thanh toán (COD, ví, thẻ)

---

### 2.3. Theo dõi & Tương tác
**Mô tả:**  
Theo dõi trạng thái đơn hàng và tương tác.

**Chức năng:**
- Theo dõi đơn hàng realtime
- Xem vị trí tài xế
- Chat / gọi điện
- Đánh giá sau khi hoàn tất

---

### 2.4. Quản lý tài khoản
**Mô tả:**  
Quản lý thông tin cá nhân.

**Chức năng:**
- Xem lịch sử đơn hàng
- Đặt lại đơn cũ
- Quản lý địa chỉ
- Quản lý ví / điểm thưởng
- Lưu quán yêu thích

---

## 👨‍🍳 3. STAFF (NHÂN VIÊN QUÁN)

### 3.1. Quản lý đơn hàng
**Mô tả:**  
Tiếp nhận và xử lý đơn hàng.

**Chức năng:**
- Nhận thông báo đơn mới
- Xem chi tiết đơn
- Chấp nhận / từ chối
- Cập nhật trạng thái:
    - Đang chuẩn bị
    - Hoàn thành
- Hủy đơn (có lý do)

---

### 3.2. Quản lý thực đơn
**Mô tả:**  
Quản lý món ăn của quán.

**Chức năng:**
- Bật / tắt món (còn / hết hàng)
- Cập nhật giá và thông tin
- Quản lý topping

---

### 3.3. Tương tác
**Mô tả:**  
Giao tiếp với khách và shipper.

**Chức năng:**
- Xác nhận đơn với shipper
- Chat / gọi điện

---

### 3.4. Trạng thái cửa hàng
**Mô tả:**  
Kiểm soát hoạt động quán.

**Chức năng:**
- Đóng / mở quán
- Xem danh sách đơn trong ngày

---

# 📌 Công nghệ sử dụng

- 🎯 Frontend: Flutter
- ⚙️ Backend: Spring Boot
- 💾 Database: (MySQL)

---


---

# 👥 Thành viên nhóm 1

- Phan Tiến Tiến

---

# 🚀 Trạng thái dự án

- 📅 Tuần 1: Phân tích & thiết kế
- 📅 Tuần 2: Hoàn thiện FE
- 📅 Tuần 3: Hoàn thiện BE
- 📅 Tuần 4: Ghép code FE&BE
- 📅 Tuần 5: Hoàn thiện, kiểm thử
