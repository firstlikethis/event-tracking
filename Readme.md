slf-event-tracking/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── th/
│   │   │       └── or/
│   │   │           └── studentloan/
│   │   │               └── event/
│   │   │                   ├── config/           # Spring Configuration
│   │   │                   ├── controller/       # Servlet Controllers
│   │   │                   ├── dao/              # Data Access Objects
│   │   │                   ├── model/            # Domain Models
│   │   │                   ├── service/          # Business Services
│   │   │                   └── util/             # Utilities
│   │   ├── resources/
│   │   │   ├── application.properties
│   │   │   └── spring/                       # XML Configuration
│   │   │       ├── applicationContext.xml
│   │   │       └── dispatcher-servlet.xml
│   │   └── webapp/
│   │       ├── WEB-INF/
│   │       │   ├── web.xml
│   │       │   └── views/                     # JSP Views
│   │       │       ├── admin/                 # Admin Pages
│   │       │       ├── visitor/               # Visitor Pages
│   │       │       └── common/                # Common Components
│   │       └── resources/
│   │           ├── css/
│   │           ├── js/
│   │           └── images/
│   └── test/
│       └── java/
└── pom.xml


-- ผู้เข้าร่วมงาน
CREATE TABLE slf_deb3.tb_visitor (
    visitor_id NUMBER PRIMARY KEY,
    fullname VARCHAR2(255) NOT NULL,
    phone_number VARCHAR2(15) NOT NULL UNIQUE,
    email VARCHAR2(255),
    visitor_type CHAR(1) NOT NULL, -- 1,2,3,4,5,6 ตามประเภทที่กำหนด
    total_points NUMBER DEFAULT 0,
    registration_date TIMESTAMP DEFAULT SYSTIMESTAMP,
    last_login_date TIMESTAMP
);

-- OTP สำหรับการยืนยันตัวตน
CREATE TABLE slf_deb3.tb_otp (
    otp_id NUMBER PRIMARY KEY,
    phone_number VARCHAR2(15) NOT NULL,
    otp_code VARCHAR2(6) NOT NULL,
    created_date TIMESTAMP DEFAULT SYSTIMESTAMP,
    expired_date TIMESTAMP,
    is_used CHAR(1) DEFAULT '0' -- 0=ยังไม่ใช้, 1=ใช้แล้ว
);

-- บูธ
CREATE TABLE slf_deb3.tb_booth (
    booth_id NUMBER PRIMARY KEY,
    booth_name VARCHAR2(255) NOT NULL,
    booth_description VARCHAR2(1000),
    points NUMBER DEFAULT 1 NOT NULL,
    qr_code_url VARCHAR2(255),
    created_date TIMESTAMP DEFAULT SYSTIMESTAMP,
    updated_date TIMESTAMP,
    is_active CHAR(1) DEFAULT '1' -- 0=ไม่ใช้งาน, 1=ใช้งาน
);

-- ประวัติการสแกน QR
CREATE TABLE slf_deb3.tb_visitor_log (
    log_id NUMBER PRIMARY KEY,
    visitor_id NUMBER NOT NULL,
    booth_id NUMBER NOT NULL,
    points_earned NUMBER NOT NULL,
    scan_date TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_visitor_log_visitor FOREIGN KEY (visitor_id) REFERENCES slf_deb3.tb_visitor(visitor_id),
    CONSTRAINT fk_visitor_log_booth FOREIGN KEY (booth_id) REFERENCES slf_deb3.tb_booth(booth_id),
    CONSTRAINT uq_visitor_booth UNIQUE (visitor_id, booth_id) -- ป้องกันการสแกนซ้ำ
);

-- ของรางวัล
CREATE TABLE slf_deb3.tb_reward (
    reward_id NUMBER PRIMARY KEY,
    reward_name VARCHAR2(255) NOT NULL,
    reward_description VARCHAR2(1000),
    reward_type CHAR(1) NOT NULL, -- 1=สำหรับลุ้น, 2=สำหรับแลกทันที
    points_required NUMBER NOT NULL,
    quantity NUMBER DEFAULT 1,
    remaining NUMBER DEFAULT 1,
    created_date TIMESTAMP DEFAULT SYSTIMESTAMP,
    updated_date TIMESTAMP,
    is_active CHAR(1) DEFAULT '1' -- 0=ไม่ใช้งาน, 1=ใช้งาน
);

-- ประวัติการแลกรางวัล
CREATE TABLE slf_deb3.tb_reward_claim (
    claim_id NUMBER PRIMARY KEY,
    visitor_id NUMBER NOT NULL,
    reward_id NUMBER NOT NULL,
    points_used NUMBER NOT NULL,
    claim_date TIMESTAMP DEFAULT SYSTIMESTAMP,
    is_lucky_draw CHAR(1) DEFAULT '0', -- 0=แลกทันที, 1=ได้จากการสุ่ม
    is_received CHAR(1) DEFAULT '0', -- 0=ยังไม่รับ, 1=รับแล้ว
    received_date TIMESTAMP,
    CONSTRAINT fk_reward_claim_visitor FOREIGN KEY (visitor_id) REFERENCES slf_deb3.tb_visitor(visitor_id),
    CONSTRAINT fk_reward_claim_reward FOREIGN KEY (reward_id) REFERENCES slf_deb3.tb_reward(reward_id)
);

-- ผู้ดูแลระบบ
CREATE TABLE slf_deb3.tb_admin (
    admin_id NUMBER PRIMARY KEY,
    username VARCHAR2(50) NOT NULL UNIQUE,
    password VARCHAR2(255) NOT NULL,
    fullname VARCHAR2(255) NOT NULL,
    role VARCHAR2(20) DEFAULT 'ADMIN',
    created_date TIMESTAMP DEFAULT SYSTIMESTAMP,
    last_login_date TIMESTAMP,
    is_active CHAR(1) DEFAULT '1' -- 0=ไม่ใช้งาน, 1=ใช้งาน
);


## สรุปความคืบหน้า

ตอนนี้เราได้พัฒนาส่วนสำคัญของระบบ SLF Event Tracking ดังนี้:

1. ✅ การตั้งค่าโปรเจคและโครงสร้างพื้นฐาน
   - ไฟล์ XML Configuration
   - Model, DAO และ Service พื้นฐาน

2. ✅ ระบบลงทะเบียนและเข้าสู่ระบบด้วย OTP (R1)
   - หน้าแรกของระบบ
   - หน้าลงทะเบียน
   - หน้าเข้าสู่ระบบด้วย OTP
   - ระบบส่ง OTP ผ่าน SMS Gateway

3. ✅ ระบบ Dashboard และการสแกน QR (R0)
   - หน้า Dashboard แสดงข้อมูลผู้ใช้และคะแนน
   - หน้าสำหรับสแกน QR Code
   - ระบบบันทึกการสแกนและคะแนน

### ส่วนที่ยังต้องพัฒนาต่อ:

1. ระบบจัดการรางวัล
   - หน้าแสดงรางวัลที่สามารถแลกได้
   - ระบบการแลกรางวัล

2. ระบบสุ่มรางวัล (R2)
   - หน้าแสดงการสุ่มรางวัล
   - ระบบสุ่มรางวัลแบบมี timeout

3. ระบบผู้ดูแล (R4)
   - ระบบ Login สำหรับผู้ดูแล
   - จัดการบูธ
   - จัดการรางวัล
   - จัดการผู้ดูแลระบบ
   - ระบบ Stamp รับรางวัล แบบ Reedeem และ ได้รับของรางวัลจากการสุ่ม

ขั้นตอนต่อไปคือการพัฒนาระบบจัดการรางวัลและการแลกรางวัล ซึ่งจะต้องสร้าง Model, DAO, Service และ Controller ที่เกี่ยวข้อง รวมถึงหน้า JSP สำหรับแสดงรางวัลและทำการแลกรางวัล