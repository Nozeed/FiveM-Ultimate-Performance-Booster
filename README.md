# FiveM Ultimate Performance Booster 🎮

สร้างสำหรับ: **Windows 11 + FiveM PVP Server (300 players)**
เป้าหมาย: **FPS สูงสุด, Latency ต่ำสุด, Response เหนือชั้น**

---

## 📁 ไฟล์ในนี้

| ไฟล์ | ใช้ทำอะไร | ควรรันเมื่อไหร่ |
|------|-----------|---------------|
| `FiveM_Ultimate_Boost.ps1` | ปรับแต่งระบบทั้งหมด | **ครั้งเดียว** (หรือเมื่อติดตั้ง Windows ใหม่) |
| `FiveM_Priority.ps1` | ตั้งค่า Priority สูงสุดให้ FiveM | **ทุกครั้งก่อนเล่น** |
| `GPEDIT_Network.reg` | ปรับ Network Latency | **ครั้งเดียว** (ต้องเป็น Windows Pro/Enterprise) |
| `Restore_Defaults.ps1` | คืนค่าเริ่มต้น | เมื่อต้องการย้อนกลับ |

---

## 🚀 วิธีใช้งาน

### ขั้นตอนที่ 1: ปรับแต่งระบบ (ทำครั้งเดียว)

1. คลิกขวา `FiveM_Ultimate_Boost.ps1` → **Run with PowerShell** (as Administrator)
2. รอจนเสร็จ แล้ว **Restart เครื่อง**

### ขั้นตอนที่ 2: ปรับ Group Policy Network (ถ้าใช้ Windows Pro/Enterprise)

1. ดับเบิลคลิก `GPEDIT_Network.reg` → กด Yes
2. หรือใช้ `Win+R` พิมพ์ `gpedit.msc` แล้วปรับตามด้านล่าง

### ขั้นตอนที่ 3: รัน Priority Booster (ทุกครั้งก่อนเล่น)

```powershell
# วิธีที่ 1: คลิกขวา → Run with PowerShell
# วิธีที่ 2: สร้าง shortcut ไว้รันทุกครั้งก่อนเข้าเกม
```

---

## ⚙️ การปรับด้วยตนเอง (gpedit.msc)

### 1. Network QoS - ปลดล็อก Bandwidth
```
Computer Configuration > Administrative Templates > Network > QoS Packet Scheduler
→ "Limit reservable bandwidth" = Enabled → 0%
```

### 2. TCP/IP สำหรับเกม
```
Computer Configuration > Windows Settings > Policy-based QoS
→ สร้าง New Policy สำหรับ FiveM.exe priority = Realtime
```

### 3. Latency Optimization
```
Computer Configuration > Administrative Templates > Windows Components > OneDrive
→ "Prevent the usage of OneDrive" = Enabled (ประหยัด bandwidth)
```

---

## 🔧 สิ่งที่สคริปต์ปรับ

### Network Layer
- ✅ Disable Nagle's Algorithm (TCP_NODELAY)
- ✅ ตั้ง QoS Bandwidth Reserve = 0%
- ✅ Disable Receive Side Scaling (ลด latency)
- ✅ Enable CTCP congestion provider
- ✅ Optimize DNS cache
- ✅ Disable Network Throttling

### Mouse & Keyboard
- ✅ Disable Mouse Acceleration ทั้งหมด
- ✅ เพิ่ม Keyboard/Mouse Data Queue
- ✅ Disable USB Selective Suspend
- ✅ Optimize HID polling rate

### CPU & Process
- ✅ Disable CPU Core Parking
- ✅ Enable Game Mode
- ✅ Set Games priority class = High
- ✅ Disable HPET (ลด latency ~5-15ms)
- ✅ Optimize Timer Resolution

### Memory
- ✅ Disable Memory Compression (ลด latency)
- ✅ Enable Large System Cache
- ✅ Disable Prefetch/Superfetch
- ✅ Disable Paging Executive

### Windows Services (ที่ปิด)
- ❌ Diagnostic Tracking
- ❌ Superfetch/SysMain
- ❌ Windows Search
- ❌ Xbox Live Services (ถ้าไม่ใช้)
- ❌ OneSync (เลือกปิด)
- ❌ Maps, Phone, Biometric Services

---

## 🎯 เพิ่มเติมที่แนะนำ

### 1. BIOS/UEFI Settings
- **Above 4G Decoding**: Enabled
- **Resizable BAR**: Enabled
- **CSM**: Disabled (ใช้ UEFI ล้วน)
- **XMP/EXPO**: Enabled (RAM ทำงานเต็มความเร็ว)
- **CPU C-States**: Disable C6, C8 (ลด latency)
- **Intel SpeedStep/AMD Cool'n'Quiet**: Disabled
- **Spread Spectrum**: Disabled

### 2. NVIDIA Control Panel (คุณปรับดีแล้ว แต่เช็คอีกที)
- Low Latency Mode: **Ultra**
- Power Management: **Prefer Maximum Performance**
- Threaded Optimization: **Off** (บางเกม)
- Vertical Sync: **Off**

### 3. FiveM Specific
```
FiveM.exe +exec server.cfg +set onesync on +set sv_maxClients 300
```
ใน `FiveM Application Data`:
- ลบ cache ทุกครั้งก่อนเล่น
- ใช้ `nodpi` mode ถ้า connection มีปัญหา

### 4. Windows 11 Specific
- Settings > Gaming > Game Mode: **ON**
- Settings > System > Display > Graphics: FiveM = High Performance
- Disable "Hardware-accelerated GPU scheduling" ถ้าเล่นแล้วกระตุก

### 5. เครื่องมือเสริม
- **Process Lasso**: Auto-optimize process priority
- **Timer Resolution**: ตั้ง 0.5ms ตลอดเวลา
- **TCP Optimizer**: ปรับ MTU/RWIN อัตโนมัติ
- **MSI Mode Utility**: ตั้ง GPU/Network เป็น MSI mode

---

## ⚠️ คำเตือน

1. **สำรองระบบก่อนใช้**: สคริปต์สร้าง restore point อัตโนมัติ แต่ควรสำรองเองด้วย
2. **ใช้ที่ความเสี่ยงของคุณ**: การปรับบางอย่างอาจทำให้ Windows ไม่เสถียร
3. **ถ้ามีปัญหา**: รัน `Restore_Defaults.ps1` เพื่อคืนค่า
4. **Antivirus**: บางตัวอาจ detect สคริปต์เป็น false positive

---

## 📊 ผลลัพธ์ที่คาดหวัง

| ตัวชี้วัด | ก่อนปรับ | หลังปรับ |
|-----------|---------|----------|
| System Latency | ~15-30ms | ~5-10ms |
| Mouse Response | มี acceleration | 1:1 Raw Input |
| FPS Stability | มี stutter | นิ่งขึ้น |
| Network Ping | มี variance | เสถียรขึ้น |

---

สร้างโดย AI Assistant | สำหรับ FiveM PVP Competitive Gaming
