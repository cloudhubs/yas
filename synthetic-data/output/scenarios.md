# Scenario Catalog

<!-- Global ID counters (tracked across all groups):
  brand: 1..50 (product_catalog group)
  category: 1..50
  product: 1..50
  Keycloak CUSTOMER UUIDs: 11111111-00NN-4000-a000-000000000NNN (N=01..50)
  Keycloak ADMIN UUID: 99999999-0001-4000-a000-000000000001
  country: 1
  state_or_province: 1..10
  district: 1..20
  address: 1..
  user_address: 1..
  cart_item: keyed (customer_id, product_id)
  checkout: 1..
  order: 1..
  rating: 1..
  promotion: 1..
  warehouse: 1..
  stock: 1..
  tax_class: 1..
  tax_rate: 1..
  payment_provider: 1..
-->

## Data State: product_catalog

*Enables flows: product_get_by_slug_public_success, product_get_featured_public_success, product_browse_public_success, product_browse_by_brand_public_success, product_browse_by_category_public_success, rating_get_product_ratings_public_success, rating_get_avg_star_public_success*

### Scenario 1 — Silk ao dai from Lụa Hà Đông

Brand "Lụa Hà Đông" sells traditional Vietnamese silk garments. Their flagship product is a blue silk ao dai, published and available for storefront browsing. Category: Áo Dài.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| product | brand | id=1, name='Lụa Hà Đông', slug='lua-ha-dong', published=true |
| product | category | id=1, name='Áo Dài', slug='ao-dai', published=true |
| product | product | id=1, name='Áo Dài Lụa Xanh Size M', slug='ao-dai-lua-xanh-m', sku='AODN-BL-M', price=850000, brand_id=1, published=true, is_allowed_to_order=true, is_featured=true, stock_tracking_enabled=false |

---

### Scenario 2 — Adidas running shoes

Brand "Adidas VN" sells international sportswear. Featured product: Adidas Ultraboost 22 Black size 42. Category: Giày Thể Thao.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| product | brand | id=2, name='Adidas VN', slug='adidas-vn', published=true |
| product | category | id=2, name='Giày Thể Thao', slug='giay-the-thao', published=true |
| product | product | id=2, name='Adidas Ultraboost 22 Đen Size 42', slug='adidas-ultraboost-22-den-42', sku='ADUB22-BLK-42', price=3200000, brand_id=2, published=true, is_allowed_to_order=true, is_featured=true, stock_tracking_enabled=false |

---

### Scenario 3 — Bat Trang ceramic tea set

Brand "Gốm Bát Tràng" sells handmade Vietnamese ceramics. Product: 6-piece ceramic tea set, published. Category: Đồ Gia Dụng.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| product | brand | id=3, name='Gốm Bát Tràng', slug='gom-bat-trang', published=true |
| product | category | id=3, name='Đồ Gia Dụng', slug='do-gia-dung', published=true |
| product | product | id=3, name='Bộ Ấm Trà Gốm Bát Tràng 6 Món', slug='bo-am-tra-gom-bat-trang', sku='CRTEA-BT-6P', price=520000, brand_id=3, published=true, is_allowed_to_order=true, is_featured=false, stock_tracking_enabled=false |

---

### Scenario 4 — Samsonite laptop backpack

Brand "Samsonite VN" sells premium luggage. Product: Guardit 2.0 15.6" black backpack. Category: Balo & Túi Xách.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| product | brand | id=4, name='Samsonite VN', slug='samsonite-vn', published=true |
| product | category | id=4, name='Balo & Túi Xách', slug='balo-tui-xach', published=true |
| product | product | id=4, name='Samsonite Guardit 2.0 15.6 Đen', slug='samsonite-guardit-20-den', sku='SAM-GU20-BLK', price=1890000, brand_id=4, published=true, is_allowed_to_order=true, is_featured=false, stock_tracking_enabled=false |

---

### Scenario 5 — Trung Nguyen premium coffee

Brand "Trung Nguyên" sells Vietnamese specialty coffee. Product: Premium Blend 500g bag. Category: Cà Phê & Trà. Featured product.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| product | brand | id=5, name='Trung Nguyên', slug='trung-nguyen', published=true |
| product | category | id=5, name='Cà Phê & Trà', slug='ca-phe-tra', published=true |
| product | product | id=5, name='Trung Nguyên Premium Blend 500g', slug='trung-nguyen-premium-500g', sku='TNPB-500G', price=145000, brand_id=5, published=true, is_allowed_to_order=true, is_featured=true, stock_tracking_enabled=false |

---

### Scenario 6 — Apple Watch SE 2nd Gen

Brand "Apple VN" sells Apple products. Product: Watch SE 2nd Gen 44mm Starlight. Category: Đồng Hồ Thông Minh. High-value featured product.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| product | brand | id=6, name='Apple VN', slug='apple-vn', published=true |
| product | category | id=6, name='Đồng Hồ Thông Minh', slug='dong-ho-thong-minh', published=true |
| product | product | id=6, name='Apple Watch SE 2nd Gen 44mm Starlight', slug='apple-watch-se2-44-starlight', sku='AW-SE2-44-STL', price=7990000, brand_id=6, published=true, is_allowed_to_order=true, is_featured=true, stock_tracking_enabled=false |

---

### Scenario 7 — L'Oréal hyaluronic acid serum

Brand "L'Oréal Paris VN" sells skincare. Product: Revitalift 3% HA Serum 30ml. Category: Chăm Sóc Da.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| product | brand | id=7, name='L''Oréal Paris VN', slug='loreal-paris-vn', published=true |
| product | category | id=7, name='Chăm Sóc Da', slug='cham-soc-da', published=true |
| product | product | id=7, name='L''Oreal Revitalift HA 3% Serum 30ml', slug='loreal-revitalift-ha3-30ml', sku='LOR-HA3-30ML', price=420000, brand_id=7, published=true, is_allowed_to_order=true, is_featured=false, stock_tracking_enabled=false |

---

### Scenario 8 — Logitech wireless gaming headset

Brand "Logitech VN" sells computer peripherals. Product: G435 LIGHTSPEED White gaming headset. Category: Thiết Bị Gaming.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| product | brand | id=8, name='Logitech VN', slug='logitech-vn', published=true |
| product | category | id=8, name='Thiết Bị Gaming', slug='thiet-bi-gaming', published=true |
| product | product | id=8, name='Logitech G435 LIGHTSPEED Trắng', slug='logitech-g435-lightspeed-trang', sku='LOG-G435-WHT', price=1590000, brand_id=8, published=true, is_allowed_to_order=true, is_featured=false, stock_tracking_enabled=false |

---

### Scenario 9 — Uji ceremonial matcha

Brand "Trà Xanh Nhật" sells Japanese health teas. Product: Uji Premium Matcha Ceremonial 100g tin. Category: Thực Phẩm Hữu Cơ.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| product | brand | id=9, name='Trà Xanh Nhật', slug='tra-xanh-nhat', published=true |
| product | category | id=9, name='Thực Phẩm Hữu Cơ', slug='thuc-pham-huu-co', published=true |
| product | product | id=9, name='Matcha Uji Ceremonial 100g', slug='matcha-uji-ceremonial-100g', sku='MATCHA-UJI-100G', price=380000, brand_id=9, published=true, is_allowed_to_order=true, is_featured=false, stock_tracking_enabled=false |

---

### Scenario 10 — Manduka PRO yoga mat

Brand "Manduka" sells premium yoga equipment. Product: PRO Yoga Mat 6mm Black. Category: Dụng Cụ Yoga & Gym. Featured.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| product | brand | id=10, name='Manduka', slug='manduka', published=true |
| product | category | id=10, name='Dụng Cụ Yoga & Gym', slug='dung-cu-yoga-gym', published=true |
| product | product | id=10, name='Manduka PRO Yoga Mat 6mm Đen', slug='manduka-pro-6mm-den', sku='MDK-PRO-6-BLK', price=2750000, brand_id=10, published=true, is_allowed_to_order=true, is_featured=true, stock_tracking_enabled=false |

---

### Scenario 11 — Mango linen shirt women

Brand "Mango VN" sells European fashion. Product: Linen Relaxed Shirt White size S. Category: Thời Trang Nữ.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| product | brand | id=11, name='Mango VN', slug='mango-vn', published=true |
| product | category | id=11, name='Thời Trang Nữ', slug='thoi-trang-nu', published=true |
| product | product | id=11, name='Mango Áo Linen Trắng Size S', slug='mango-linen-shirt-white-s', sku='MNG-LIN-WHT-S', price=790000, brand_id=11, published=true, is_allowed_to_order=true, is_featured=false, stock_tracking_enabled=false |

---

### Scenario 12 — Dyson V12 cordless vacuum

Brand "Dyson VN" sells premium home appliances. Product: V12 Detect Slim Nickel/Yellow. Category: Máy Hút Bụi. High-value featured.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| product | brand | id=12, name='Dyson VN', slug='dyson-vn', published=true |
| product | category | id=12, name='Máy Hút Bụi', slug='may-hut-bui', published=true |
| product | product | id=12, name='Dyson V12 Detect Slim Nickel', slug='dyson-v12-detect-slim-nickel', sku='DYS-V12-NKL', price=12990000, brand_id=12, published=true, is_allowed_to_order=true, is_featured=true, stock_tracking_enabled=false |

---

### Scenario 13 — Doraemon color special edition book

Brand "NXB Kim Đồng" sells Vietnamese children's books. Product: Doraemon Màu Đặc Biệt Vol.1, paperback. Category: Sách Thiếu Nhi.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| product | brand | id=13, name='NXB Kim Đồng', slug='nxb-kim-dong', published=true |
| product | category | id=13, name='Sách Thiếu Nhi', slug='sach-thieu-nhi', published=true |
| product | product | id=13, name='Doraemon Màu Đặc Biệt Vol.1', slug='doraemon-mau-dac-biet-vol1', sku='BK-DOR-C01-VN', price=68000, brand_id=13, published=true, is_allowed_to_order=true, is_featured=false, stock_tracking_enabled=false |

---

### Scenario 14 — Xiaomi LED desk lamp

Brand "Xiaomi VN" sells smart home electronics. Product: Mi LED Desk Lamp 1S White. Category: Đèn Bàn & Đèn Ngủ.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| product | brand | id=14, name='Xiaomi VN', slug='xiaomi-vn', published=true |
| product | category | id=14, name='Đèn Bàn & Đèn Ngủ', slug='den-ban-den-ngu', published=true |
| product | product | id=14, name='Xiaomi Mi LED Desk Lamp 1S Trắng', slug='xiaomi-mi-led-desk-1s', sku='XIOMI-MLED1S-WHT', price=690000, brand_id=14, published=true, is_allowed_to_order=true, is_featured=false, stock_tracking_enabled=false |

---

### Scenario 15 — Joseph Joseph bamboo cutting board set

Brand "Joseph Joseph VN" sells kitchen tools. Product: Folio 4-piece Bamboo Cutting Board Set. Category: Dụng Cụ Nhà Bếp.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| product | brand | id=15, name='Joseph Joseph VN', slug='joseph-joseph-vn', published=true |
| product | category | id=15, name='Dụng Cụ Nhà Bếp', slug='dung-cu-nha-bep', published=true |
| product | product | id=15, name='Joseph Joseph Folio Thớt Tre 4 Món', slug='jj-folio-bamboo-4-piece', sku='JJ-FOLIO-BMB-4P', price=850000, brand_id=15, published=true, is_allowed_to_order=true, is_featured=false, stock_tracking_enabled=false |

---

### Scenario 16 — Now Foods Vitamin C supplement

Brand "Now Foods VN" sells health supplements. Product: Vitamin C-1000 Sustained Release 100 tablets. Category: Thực Phẩm Bổ Sung.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| product | brand | id=16, name='Now Foods VN', slug='now-foods-vn', published=true |
| product | category | id=16, name='Thực Phẩm Bổ Sung', slug='thuc-pham-bo-sung', published=true |
| product | product | id=16, name='Now Foods Vitamin C-1000 100 viên', slug='now-foods-vitamin-c1000-100t', sku='NOW-VC1000-100T', price=310000, brand_id=16, published=true, is_allowed_to_order=true, is_featured=false, stock_tracking_enabled=false |

---

### Scenario 17 — Keychron K2 Pro mechanical keyboard

Brand "Keychron" sells mechanical keyboards. Product: K2 Pro Wireless Red Switch hot-swap. Category: Bàn Phím.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| product | brand | id=17, name='Keychron', slug='keychron', published=true |
| product | category | id=17, name='Bàn Phím', slug='ban-phim', published=true |
| product | product | id=17, name='Keychron K2 Pro Wireless Red Switch', slug='keychron-k2-pro-red', sku='KEYCHR-K2PRO-RED', price=2490000, brand_id=17, published=true, is_allowed_to_order=true, is_featured=true, stock_tracking_enabled=false |

---

### Scenario 18 — Khaisilk handpainted scarf

Brand "Khaisilk" sells luxury Vietnamese silk accessories. Product: Handpainted Silk Scarf 180×45cm Floral. Category: Phụ Kiện Thời Trang.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| product | brand | id=18, name='Khaisilk', slug='khaisilk', published=true |
| product | category | id=18, name='Phụ Kiện Thời Trang', slug='phu-kien-thoi-trang', published=true |
| product | product | id=18, name='Khăn Lụa Khaisilk Vẽ Tay Hoa 180x45', slug='khaisilk-hoa-180x45', sku='KHS-SLK-FLR-01', price=1200000, brand_id=18, published=true, is_allowed_to_order=true, is_featured=false, stock_tracking_enabled=false |

---

### Scenario 19 — JBL Flip 6 bluetooth speaker

Brand "JBL VN" sells portable audio. Product: Flip 6 Portable Bluetooth Speaker Teal. Category: Loa Bluetooth. Featured.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| product | brand | id=19, name='JBL VN', slug='jbl-vn', published=true |
| product | category | id=19, name='Loa Bluetooth', slug='loa-bluetooth', published=true |
| product | product | id=19, name='JBL Flip 6 Xanh Lá', slug='jbl-flip6-teal', sku='JBL-FLIP6-TEAL', price=2990000, brand_id=19, published=true, is_allowed_to_order=true, is_featured=true, stock_tracking_enabled=false |

---

### Scenario 20 — Haworthia succulent in ceramic pot

Brand "Vườn Xanh" sells indoor plants. Product: Haworthia Cooperi in 10cm ceramic pot. Category: Cây Cảnh.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| product | brand | id=20, name='Vườn Xanh', slug='vuon-xanh', published=true |
| product | category | id=20, name='Cây Cảnh', slug='cay-canh', published=true |
| product | product | id=20, name='Haworthia Cooperi Chậu Gốm 10cm', slug='haworthia-cooperi-10cm', sku='PLT-HAW-COP-10CM', price=95000, brand_id=20, published=true, is_allowed_to_order=true, is_featured=false, stock_tracking_enabled=false |

---

### Scenario 21 — Cuckoo electric pressure rice cooker

Brand "Cuckoo VN" sells Korean kitchen appliances. Product: CRP-P0609S 6-Cup Electric Pressure Rice Cooker Silver. Category: Nồi Cơm Điện. Featured.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| product | brand | id=21, name='Cuckoo VN', slug='cuckoo-vn', published=true |
| product | category | id=21, name='Nồi Cơm Điện', slug='noi-com-dien', published=true |
| product | product | id=21, name='Cuckoo CRP-P0609S 6 Chén Bạc', slug='cuckoo-crp-p0609s-silver', sku='CCK-CRP-P0609S-SLV', price=5490000, brand_id=21, published=true, is_allowed_to_order=true, is_featured=true, stock_tracking_enabled=false |

---

### Scenario 22 — Shimano spinning reel combo

Brand "Shimano VN" sells fishing equipment. Product: Sienna FE 2500 Spinning Reel Combo Kit. Category: Đồ Câu Cá.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| product | brand | id=22, name='Shimano VN', slug='shimano-vn', published=true |
| product | category | id=22, name='Đồ Câu Cá', slug='do-cau-ca', published=true |
| product | product | id=22, name='Shimano Sienna FE 2500 Combo', slug='shimano-sienna-fe2500-kit', sku='SHM-SIEN-FE2500-KIT', price=890000, brand_id=22, published=true, is_allowed_to_order=true, is_featured=false, stock_tracking_enabled=false |

---

### Scenario 23 — COSRX AHA/BHA toner

Brand "COSRX VN" sells Korean skincare. Product: AHA/BHA Clarifying Treatment Toner 150ml. Category: Toner & Nước Hoa Hồng.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| product | brand | id=23, name='COSRX VN', slug='cosrx-vn', published=true |
| product | category | id=23, name='Toner & Nước Hoa Hồng', slug='toner-nuoc-hoa-hong', published=true |
| product | product | id=23, name='COSRX AHA/BHA Toner 150ml', slug='cosrx-aha-bha-toner-150ml', sku='COSRX-AHA-BHA-150ML', price=285000, brand_id=23, published=true, is_allowed_to_order=true, is_featured=false, stock_tracking_enabled=false |

---

### Scenario 24 — Garmin Forerunner 255 charging cable

Brand "Garmin VN" sells GPS wearables and accessories. Product: USB Charging Cable for Forerunner 255. Category: Phụ Kiện Đồng Hồ.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| product | brand | id=24, name='Garmin VN', slug='garmin-vn', published=true |
| product | category | id=24, name='Phụ Kiện Đồng Hồ', slug='phu-kien-dong-ho', published=true |
| product | product | id=24, name='Cáp Sạc Garmin Forerunner 255', slug='garmin-chg-fr255', sku='GAR-CHG-FR255', price=290000, brand_id=24, published=true, is_allowed_to_order=true, is_featured=false, stock_tracking_enabled=false |

---

### Scenario 25 — Tefal non-stick frying pan 28cm

Brand "Tefal VN" sells non-stick cookware. Product: Easy Cook & Clean Frying Pan 28cm Red. Category: Chảo & Xoong.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| product | brand | id=25, name='Tefal VN', slug='tefal-vn', published=true |
| product | category | id=25, name='Chảo & Xoong', slug='chao-xoong', published=true |
| product | product | id=25, name='Tefal Easy Cook & Clean Chảo 28cm Đỏ', slug='tefal-ecc-28-red', sku='TFL-ECC-28-RED', price=690000, brand_id=25, published=true, is_allowed_to_order=true, is_featured=false, stock_tracking_enabled=false |

---

### Scenario 26 — Lacoste Classic Fit Polo shirt

Brand "Lacoste VN" sells French sportswear. Product: Classic Fit L1212 Polo Navy size M. Category: Thời Trang Nam.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| product | brand | id=26, name='Lacoste VN', slug='lacoste-vn', published=true |
| product | category | id=26, name='Thời Trang Nam', slug='thoi-trang-nam', published=true |
| product | product | id=26, name='Lacoste Classic Polo Navy Size M', slug='lacoste-polo-l1212-navy-m', sku='LAC-POLO-L1212-NVY-M', price=1850000, brand_id=26, published=true, is_allowed_to_order=true, is_featured=false, stock_tracking_enabled=false |

---

### Scenario 27 — Giant ARX 20 kids mountain bike

Brand "Giant VN" sells bicycles. Product: ARX 20 Kids Mountain Bike 2024 Blue. Category: Xe Đạp Trẻ Em. Featured.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| product | brand | id=27, name='Giant VN', slug='giant-vn', published=true |
| product | category | id=27, name='Xe Đạp Trẻ Em', slug='xe-dap-tre-em', published=true |
| product | product | id=27, name='GIANT ARX 20 Xe Đạp Trẻ Em Xanh 2024', slug='giant-arx-20-blue', sku='GNT-ARX-20-BLU', price=4290000, brand_id=27, published=true, is_allowed_to_order=true, is_featured=true, stock_tracking_enabled=false |

---

### Scenario 28 — Anker PowerCore 20000mAh power bank

Brand "Anker VN" sells portable power accessories. Product: PowerCore Essential 20000mAh Black. Category: Pin Sạc Dự Phòng.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| product | brand | id=28, name='Anker VN', slug='anker-vn', published=true |
| product | category | id=28, name='Pin Sạc Dự Phòng', slug='pin-sac-du-phong', published=true |
| product | product | id=28, name='Anker PowerCore 20000mAh Đen', slug='anker-powercore-20000-black', sku='ANK-A1268-BLK', price=1090000, brand_id=28, published=true, is_allowed_to_order=true, is_featured=false, stock_tracking_enabled=false |

---

### Scenario 29 — Ravensburger Hoi An 1000-piece puzzle

Brand "Ravensburger VN" sells premium jigsaw puzzles. Product: 1000-Piece Hoi An Ancient Town puzzle. Category: Đồ Chơi & Trò Chơi.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| product | brand | id=29, name='Ravensburger VN', slug='ravensburger-vn', published=true |
| product | category | id=29, name='Đồ Chơi & Trò Chơi', slug='do-choi-tro-choi', published=true |
| product | product | id=29, name='Ravensburger Puzzle Hội An 1000 Mảnh', slug='ravensburger-hoi-an-1000', sku='RAV-HOI-1000-VN', price=395000, brand_id=29, published=true, is_allowed_to_order=true, is_featured=false, stock_tracking_enabled=false |

---

### Scenario 30 — Chanel Chance Eau Tendre EDP 50ml

Brand "Chanel VN" sells luxury fragrance. Product: Chance Eau Tendre EDP 50ml. Category: Nước Hoa. High-value featured.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| product | brand | id=30, name='Chanel VN', slug='chanel-vn', published=true |
| product | category | id=30, name='Nước Hoa', slug='nuoc-hoa', published=true |
| product | product | id=30, name='Chanel Chance Eau Tendre EDP 50ml', slug='chanel-chance-tendre-edp-50ml', sku='CHL-CHTE-EDP-50ML', price=4500000, brand_id=30, published=true, is_allowed_to_order=true, is_featured=true, stock_tracking_enabled=false |

---

### Scenario 31 — TP-Link Archer AX73 WiFi 6 router

Brand "TP-Link VN" sells networking equipment. Product: Archer AX73 WiFi 6 Router White. Category: Router & Mạng.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| product | brand | id=31, name='TP-Link VN', slug='tp-link-vn', published=true |
| product | category | id=31, name='Router & Mạng', slug='router-mang', published=true |
| product | product | id=31, name='TP-Link Archer AX73 WiFi 6 Trắng', slug='tp-link-archer-ax73-white', sku='TPL-AX73-WH', price=3490000, brand_id=31, published=true, is_allowed_to_order=true, is_featured=false, stock_tracking_enabled=false |

---

### Scenario 32 — Plant Therapy lavender essential oil

Brand "Plant Therapy VN" sells therapeutic essential oils. Product: Lavender Essential Oil 30ml. Category: Tinh Dầu & Xông Phòng.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| product | brand | id=32, name='Plant Therapy VN', slug='plant-therapy-vn', published=true |
| product | category | id=32, name='Tinh Dầu & Xông Phòng', slug='tinh-dau-xong-phong', published=true |
| product | product | id=32, name='Plant Therapy Tinh Dầu Oải Hương 30ml', slug='plant-therapy-lavender-30ml', sku='PT-LAV-30ML', price=280000, brand_id=32, published=true, is_allowed_to_order=true, is_featured=false, stock_tracking_enabled=false |

---

### Scenario 33 — Optimum Nutrition Gold Standard Whey 2lb

Brand "Optimum Nutrition VN" sells sports nutrition. Product: Gold Standard Whey Protein Double Rich Chocolate 2lb. Category: Dinh Dưỡng Thể Thao. Featured.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| product | brand | id=33, name='Optimum Nutrition VN', slug='optimum-nutrition-vn', published=true |
| product | category | id=33, name='Dinh Dưỡng Thể Thao', slug='dinh-duong-the-thao', published=true |
| product | product | id=33, name='ON Gold Standard Whey Double Chocolate 2lb', slug='on-gold-standard-drc-2lb', sku='ON-GS-WHEY-DRC-2LB', price=1190000, brand_id=33, published=true, is_allowed_to_order=true, is_featured=true, stock_tracking_enabled=false |

---

### Scenario 34 — Hobonichi Techo A6 2025 planner

Brand "Hobonichi VN" sells Japanese stationery. Product: Techo A6 2025 Cousin Avec. Category: Sổ Tay & Văn Phòng Phẩm.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| product | brand | id=34, name='Hobonichi VN', slug='hobonichi-vn', published=true |
| product | category | id=34, name='Sổ Tay & Văn Phòng Phẩm', slug='so-tay-van-phong-pham', published=true |
| product | product | id=34, name='Hobonichi Techo A6 2025 Cousin Avec', slug='hobonichi-a6-2025-cousin', sku='HOB-TECHO-A6-2025-CV', price=890000, brand_id=34, published=true, is_allowed_to_order=true, is_featured=false, stock_tracking_enabled=false |

---

### Scenario 35 — Anessa Perfect UV Sunscreen SPF50+ 60ml

Brand "Anessa VN" sells Japanese sun care. Product: Perfect UV Skincare Milk SPF50+ PA++++ 60ml. Category: Kem Chống Nắng. Featured.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| product | brand | id=35, name='Anessa VN', slug='anessa-vn', published=true |
| product | category | id=35, name='Kem Chống Nắng', slug='kem-chong-nang', published=true |
| product | product | id=35, name='Anessa Perfect UV SPF50+ 60ml', slug='anessa-perfect-uv-spf50-60ml', sku='ANS-PUV-SPF50-60ML', price=620000, brand_id=35, published=true, is_allowed_to_order=true, is_featured=true, stock_tracking_enabled=false |

---

### Scenario 36 — Spigen Ultra Hybrid case iPhone 15 Pro

Brand "Spigen VN" sells phone protection. Product: Ultra Hybrid Case iPhone 15 Pro Crystal Clear. Category: Ốp Lưng Điện Thoại.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| product | brand | id=36, name='Spigen VN', slug='spigen-vn', published=true |
| product | category | id=36, name='Ốp Lưng Điện Thoại', slug='op-lung-dien-thoai', published=true |
| product | product | id=36, name='Spigen Ultra Hybrid iPhone 15 Pro Crystal Clear', slug='spigen-uh-ip15p-crystal', sku='SPN-UH-IP15P-CRY', price=395000, brand_id=36, published=true, is_allowed_to_order=true, is_featured=false, stock_tracking_enabled=false |

---

### Scenario 37 — Dyson Supersonic hair dryer fuchsia/gold

Brand "Dyson VN" sells premium hair tools. Product: Supersonic Hair Dryer Fuchsia/Gold. Category: Máy Sấy Tóc. High-value featured.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| product | brand | id=37, name='Dyson VN Hair', slug='dyson-vn-hair', published=true |
| product | category | id=37, name='Máy Sấy Tóc', slug='may-say-toc', published=true |
| product | product | id=37, name='Dyson Supersonic Fuchsia/Gold', slug='dyson-supersonic-fuchsia-gold', sku='DYS-SUPSNC-GLD', price=16500000, brand_id=37, published=true, is_allowed_to_order=true, is_featured=true, stock_tracking_enabled=false |

---

### Scenario 38 — Trtl Travel Pillow Plus navy

Brand "Trtl VN" sells travel comfort accessories. Product: Travel Pillow Plus Navy. Category: Phụ Kiện Du Lịch.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| product | brand | id=38, name='Trtl VN', slug='trtl-vn', published=true |
| product | category | id=38, name='Phụ Kiện Du Lịch', slug='phu-kien-du-lich', published=true |
| product | product | id=38, name='Trtl Travel Pillow Plus Navy', slug='trtl-plus-navy', sku='TRTL-PLUS-NVY', price=790000, brand_id=38, published=true, is_allowed_to_order=true, is_featured=false, stock_tracking_enabled=false |

---

### Scenario 39 — Cuisinart Classic Waffle Maker stainless

Brand "Cuisinart VN" sells kitchen appliances. Product: Classic Waffle Maker WMB-4 Stainless Steel. Category: Thiết Bị Nhà Bếp Nhỏ.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| product | brand | id=39, name='Cuisinart VN', slug='cuisinart-vn', published=true |
| product | category | id=39, name='Thiết Bị Nhà Bếp Nhỏ', slug='thiet-bi-nha-bep-nho', published=true |
| product | product | id=39, name='Cuisinart WMB-4 Máy Làm Waffle Inox', slug='cuisinart-wmb4-stainless', sku='CSN-WMB4-SS', price=1490000, brand_id=39, published=true, is_allowed_to_order=true, is_featured=false, stock_tracking_enabled=false |

---

### Scenario 40 — Wacom Intuos Small wireless drawing tablet

Brand "Wacom VN" sells creative input devices. Product: Intuos Small Wireless Black. Category: Bảng Vẽ Điện Tử. Featured.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| product | brand | id=40, name='Wacom VN', slug='wacom-vn', published=true |
| product | category | id=40, name='Bảng Vẽ Điện Tử', slug='bang-ve-dien-tu', published=true |
| product | product | id=40, name='Wacom Intuos Small Wireless Đen', slug='wacom-intuos-small-wireless-black', sku='WAC-CTL-4100WL-BLK', price=2190000, brand_id=40, published=true, is_allowed_to_order=true, is_featured=true, stock_tracking_enabled=false |

---

### Scenario 41 — Enfamil NeuroPro infant formula 865g

Brand "Enfamil VN" sells infant nutrition. Product: NeuroPro Infant Formula 865g. Category: Sữa Bột Trẻ Em.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| product | brand | id=41, name='Enfamil VN', slug='enfamil-vn', published=true |
| product | category | id=41, name='Sữa Bột Trẻ Em', slug='sua-bot-tre-em', published=true |
| product | product | id=41, name='Enfamil NeuroPro Infant 865g', slug='enfamil-neuropro-865g', sku='ENF-NRPRO-865G', price=780000, brand_id=41, published=true, is_allowed_to_order=true, is_featured=false, stock_tracking_enabled=false |

---

### Scenario 42 — Winmau Blade 6 professional dartboard

Brand "Winmau VN" sells dart equipment. Product: Blade 6 Professional Bristle Dartboard Black. Category: Dụng Cụ Thể Thao Trong Nhà.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| product | brand | id=42, name='Winmau VN', slug='winmau-vn', published=true |
| product | category | id=42, name='Dụng Cụ Thể Thao Trong Nhà', slug='dung-cu-the-thao-trong-nha', published=true |
| product | product | id=42, name='Winmau Blade 6 Dartboard Đen', slug='winmau-blade6-black', sku='WIN-BLADE6-BLK', price=1350000, brand_id=42, published=true, is_allowed_to_order=true, is_featured=false, stock_tracking_enabled=false |

---

### Scenario 43 — Sistema Brilliance 1.6L food container

Brand "Sistema VN" sells food storage. Product: Brilliance Rectangular Container 1.6L Clear. Category: Hộp Đựng Thực Phẩm.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| product | brand | id=43, name='Sistema VN', slug='sistema-vn', published=true |
| product | category | id=43, name='Hộp Đựng Thực Phẩm', slug='hop-dung-thuc-pham', published=true |
| product | product | id=43, name='Sistema Brilliance Container 1.6L Trong Suốt', slug='sistema-brilliance-1600-clear', sku='SIS-BRIL-1600-CL', price=185000, brand_id=43, published=true, is_allowed_to_order=true, is_featured=false, stock_tracking_enabled=false |

---

### Scenario 44 — Sony WF-1000XM5 noise-cancelling earbuds

Brand "Sony VN" sells premium audio. Product: WF-1000XM5 Wireless Noise Cancelling Earbuds Black. Category: Tai Nghe True Wireless. Featured.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| product | brand | id=44, name='Sony VN', slug='sony-vn', published=true |
| product | category | id=44, name='Tai Nghe True Wireless', slug='tai-nghe-true-wireless', published=true |
| product | product | id=44, name='Sony WF-1000XM5 Đen', slug='sony-wf1000xm5-black', sku='SNY-WF1000XM5-BLK', price=6490000, brand_id=44, published=true, is_allowed_to_order=true, is_featured=true, stock_tracking_enabled=false |

---

### Scenario 45 — Hydro Flask Wide Mouth 32oz flamingo pink

Brand "Hydro Flask VN" sells insulated water bottles. Product: Wide Mouth 32oz Stainless Flamingo Pink. Category: Bình Nước.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| product | brand | id=45, name='Hydro Flask VN', slug='hydro-flask-vn', published=true |
| product | category | id=45, name='Bình Nước', slug='binh-nuoc', published=true |
| product | product | id=45, name='Hydro Flask Wide Mouth 32oz Hồng Flamingo', slug='hydro-flask-wm-32-flamingo', sku='HF-WM-32-PNK', price=1190000, brand_id=45, published=true, is_allowed_to_order=true, is_featured=false, stock_tracking_enabled=false |

---

### Scenario 46 — Anker Nebula Capsule II mini projector

Brand "Anker Nebula VN" sells portable projectors. Product: Nebula Capsule II Smart Mini Projector Black. Category: Máy Chiếu. High-value featured.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| product | brand | id=46, name='Anker Nebula VN', slug='anker-nebula-vn', published=true |
| product | category | id=46, name='Máy Chiếu', slug='may-chieu', published=true |
| product | product | id=46, name='Anker Nebula Capsule II Đen', slug='anker-nebula-capsule2-black', sku='ANK-NEB-CAP2-BLK', price=9990000, brand_id=46, published=true, is_allowed_to_order=true, is_featured=true, stock_tracking_enabled=false |

---

### Scenario 47 — Oral-B iO Series 7 electric toothbrush

Brand "Oral-B VN" sells electric dental care. Product: iO Series 7 Onyx Black. Category: Bàn Chải Điện.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| product | brand | id=47, name='Oral-B VN', slug='oral-b-vn', published=true |
| product | category | id=47, name='Bàn Chải Điện', slug='ban-chai-dien', published=true |
| product | product | id=47, name='Oral-B iO Series 7 Đen Onyx', slug='oral-b-io7-onyx-black', sku='ORB-IO7-BLK', price=3990000, brand_id=47, published=true, is_allowed_to_order=true, is_featured=false, stock_tracking_enabled=false |

---

### Scenario 48 — Vietnamese regional cuisine cookbook

Brand "NXB Thanh Niên" sells Vietnamese books. Product: Bếp Việt 100 Món Ăn Truyền Thống Miền Trung, hardcover. Category: Sách Nấu Ăn.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| product | brand | id=48, name='NXB Thanh Niên', slug='nxb-thanh-nien', published=true |
| product | category | id=48, name='Sách Nấu Ăn', slug='sach-nau-an', published=true |
| product | product | id=48, name='Bếp Việt 100 Món Ăn Miền Trung Bìa Cứng', slug='bep-viet-mien-trung-hardcover', sku='BK-BEPVIET-MT-01', price=210000, brand_id=48, published=true, is_allowed_to_order=true, is_featured=false, stock_tracking_enabled=false |

---

### Scenario 49 — Spigen GTS300 MagSafe car phone holder

Brand "Spigen VN Car" sells car accessories. Product: GTS300 MagSafe Car Phone Holder Black. Category: Phụ Kiện Ô Tô.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| product | brand | id=49, name='Spigen VN Car', slug='spigen-vn-car', published=true |
| product | category | id=49, name='Phụ Kiện Ô Tô', slug='phu-kien-o-to', published=true |
| product | product | id=49, name='Spigen GTS300 Giá Đỡ Ô Tô MagSafe Đen', slug='spigen-gts300-magsafe-black', sku='SPN-GTS300-BLK', price=590000, brand_id=49, published=true, is_allowed_to_order=true, is_featured=false, stock_tracking_enabled=false |

---

### Scenario 50 — Diptyque Baies scented candle 190g

Brand "Diptyque VN" sells luxury home fragrance. Product: Baies Scented Candle 190g. Category: Nến Thơm. High-value featured.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| product | brand | id=50, name='Diptyque VN', slug='diptyque-vn', published=true |
| product | category | id=50, name='Nến Thơm', slug='nen-thom', published=true |
| product | product | id=50, name='Diptyque Baies Scented Candle 190g', slug='diptyque-baies-190g', sku='DIP-BAIES-190G', price=1850000, brand_id=50, published=true, is_allowed_to_order=true, is_featured=true, stock_tracking_enabled=false |

---

## Data State: customer_with_cart

*Enables flows: cart_add_item_customer_success, cart_get_items_customer_success, cart_update_item_customer_success, cart_delete_item_customer_success, cart_remove_items_customer_success, customer_get_profile_customer_success*

*Depends on: product_catalog group (products 1–50 already seeded)*

*Keycloak UUID pattern: `aaaaaaaa-00NN-4000-a000-000000000NNN` (N=01..50)*

### Scenario 1 — Nguyen Thi Lan has ao dai in cart

Nguyen Thi Lan from Hanoi has a blue silk ao dai (product_id=1, qty=1) in her cart.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| cart | cart_item | customer_id='aaaaaaaa-0001-4000-a000-000000000001', product_id=1, quantity=1 |

Keycloak: `id=aaaaaaaa-0001-4000-a000-000000000001, username=cart_lan, email=cart_lan@test.com, role=CUSTOMER`

---

### Scenario 2 — Tran Van Minh has running shoes in cart

Tran Van Minh from Ho Chi Minh City has Adidas Ultraboost (product_id=2, qty=1) in his cart.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| cart | cart_item | customer_id='aaaaaaaa-0002-4000-a000-000000000002', product_id=2, quantity=1 |

Keycloak: `id=aaaaaaaa-0002-4000-a000-000000000002, username=cart_minh, email=cart_minh@test.com, role=CUSTOMER`

---

### Scenario 3 — Le Thi Hoa has 2 tea sets in cart

Le Thi Hoa from Da Nang has 2 Bat Trang ceramic tea sets (product_id=3, qty=2) — one for herself, one as a gift.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| cart | cart_item | customer_id='aaaaaaaa-0003-4000-a000-000000000003', product_id=3, quantity=2 |

Keycloak: `id=aaaaaaaa-0003-4000-a000-000000000003, username=cart_hoa, email=cart_hoa@test.com, role=CUSTOMER`

---

### Scenario 4 — Pham Duc Hung has laptop backpack in cart

Pham Duc Hung from Can Tho has Samsonite Guardit 2.0 (product_id=4, qty=1) in his cart ahead of a new semester.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| cart | cart_item | customer_id='aaaaaaaa-0004-4000-a000-000000000004', product_id=4, quantity=1 |

Keycloak: `id=aaaaaaaa-0004-4000-a000-000000000004, username=cart_hung, email=cart_hung@test.com, role=CUSTOMER`

---

### Scenario 5 — Hoang Thi Thu has 3 coffee bags in cart

Hoang Thi Thu from Hue stocked up with 3 Trung Nguyen Premium Blend bags (product_id=5, qty=3).

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| cart | cart_item | customer_id='aaaaaaaa-0005-4000-a000-000000000005', product_id=5, quantity=3 |

Keycloak: `id=aaaaaaaa-0005-4000-a000-000000000005, username=cart_thu, email=cart_thu@test.com, role=CUSTOMER`

---

### Scenario 6 — Vo Van Thanh has Apple Watch in cart

Vo Van Thanh from Bien Hoa has Apple Watch SE 2nd Gen (product_id=6, qty=1) in his cart for a self-gift.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| cart | cart_item | customer_id='aaaaaaaa-0006-4000-a000-000000000006', product_id=6, quantity=1 |

Keycloak: `id=aaaaaaaa-0006-4000-a000-000000000006, username=cart_thanh, email=cart_thanh@test.com, role=CUSTOMER`

---

### Scenario 7 — Nguyen Thi Bich has 2 serums in cart

Nguyen Thi Bich from Hanoi has 2 L'Oréal HA Serums (product_id=7, qty=2) — one to use, one to stock.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| cart | cart_item | customer_id='aaaaaaaa-0007-4000-a000-000000000007', product_id=7, quantity=2 |

Keycloak: `id=aaaaaaaa-0007-4000-a000-000000000007, username=cart_bich, email=cart_bich@test.com, role=CUSTOMER`

---

### Scenario 8 — Do Manh Cuong has gaming headset in cart

Do Manh Cuong from Ho Chi Minh City has Logitech G435 (product_id=8, qty=1) saved in cart.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| cart | cart_item | customer_id='aaaaaaaa-0008-4000-a000-000000000008', product_id=8, quantity=1 |

Keycloak: `id=aaaaaaaa-0008-4000-a000-000000000008, username=cart_cuong, email=cart_cuong@test.com, role=CUSTOMER`

---

### Scenario 9 — Tran Thi Oanh has 2 matcha tins in cart

Tran Thi Oanh from Hoi An has 2 Uji Ceremonial Matcha tins (product_id=9, qty=2) in her cart.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| cart | cart_item | customer_id='aaaaaaaa-0009-4000-a000-000000000009', product_id=9, quantity=2 |

Keycloak: `id=aaaaaaaa-0009-4000-a000-000000000009, username=cart_oanh, email=cart_oanh@test.com, role=CUSTOMER`

---

### Scenario 10 — Bui Van Duc has yoga mat in cart

Bui Van Duc from Vung Tau has Manduka PRO mat (product_id=10, qty=1) waiting in his cart.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| cart | cart_item | customer_id='aaaaaaaa-0010-4000-a000-000000000010', product_id=10, quantity=1 |

Keycloak: `id=aaaaaaaa-0010-4000-a000-000000000010, username=cart_duc, email=cart_duc@test.com, role=CUSTOMER`

---

### Scenario 11 — Ly Thi Phuong has linen shirt in cart

Ly Thi Phuong from Nha Trang has Mango Linen Shirt White S (product_id=11, qty=1) in her cart.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| cart | cart_item | customer_id='aaaaaaaa-0011-4000-a000-000000000011', product_id=11, quantity=1 |

Keycloak: `id=aaaaaaaa-0011-4000-a000-000000000011, username=cart_phuong, email=cart_phuong@test.com, role=CUSTOMER`

---

### Scenario 12 — Nguyen Van An has vacuum cleaner in cart

Nguyen Van An from Hai Phong has Dyson V12 (product_id=12, qty=1) in his cart for the new apartment.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| cart | cart_item | customer_id='aaaaaaaa-0012-4000-a000-000000000012', product_id=12, quantity=1 |

Keycloak: `id=aaaaaaaa-0012-4000-a000-000000000012, username=cart_an, email=cart_an@test.com, role=CUSTOMER`

---

### Scenario 13 — Dang Thi Lien has 2 Doraemon books in cart

Dang Thi Lien from Ho Chi Minh City has 2 Doraemon Vol.1 (product_id=13, qty=2) for niece's birthday.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| cart | cart_item | customer_id='aaaaaaaa-0013-4000-a000-000000000013', product_id=13, quantity=2 |

Keycloak: `id=aaaaaaaa-0013-4000-a000-000000000013, username=cart_lien, email=cart_lien@test.com, role=CUSTOMER`

---

### Scenario 14 — Phan Thi Xuan has desk lamp in cart

Phan Thi Xuan from Da Lat has Xiaomi Mi LED Desk Lamp 1S (product_id=14, qty=1) in cart.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| cart | cart_item | customer_id='aaaaaaaa-0014-4000-a000-000000000014', product_id=14, quantity=1 |

Keycloak: `id=aaaaaaaa-0014-4000-a000-000000000014, username=cart_xuan, email=cart_xuan@test.com, role=CUSTOMER`

---

### Scenario 15 — Truong Van Long has cutting board set in cart

Truong Van Long from Bien Hoa has Joseph Joseph Folio 4-piece set (product_id=15, qty=1) in cart.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| cart | cart_item | customer_id='aaaaaaaa-0015-4000-a000-000000000015', product_id=15, quantity=1 |

Keycloak: `id=aaaaaaaa-0015-4000-a000-000000000015, username=cart_long, email=cart_long@test.com, role=CUSTOMER`

---

### Scenario 16 — Cao Thi Nga has 2 vitamin C bottles in cart

Cao Thi Nga from Hanoi has 2 Now Foods Vitamin C-1000 (product_id=16, qty=2) stocked in cart.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| cart | cart_item | customer_id='aaaaaaaa-0016-4000-a000-000000000016', product_id=16, quantity=2 |

Keycloak: `id=aaaaaaaa-0016-4000-a000-000000000016, username=cart_nga, email=cart_nga@test.com, role=CUSTOMER`

---

### Scenario 17 — Mai Van Son has mechanical keyboard in cart

Mai Van Son from Ho Chi Minh City has Keychron K2 Pro Red (product_id=17, qty=1) in cart.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| cart | cart_item | customer_id='aaaaaaaa-0017-4000-a000-000000000017', product_id=17, quantity=1 |

Keycloak: `id=aaaaaaaa-0017-4000-a000-000000000017, username=cart_son, email=cart_son@test.com, role=CUSTOMER`

---

### Scenario 18 — Vo Thi Kim has silk scarf in cart

Vo Thi Kim from Hue has Khaisilk Floral Scarf (product_id=18, qty=1) in cart as a gift.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| cart | cart_item | customer_id='aaaaaaaa-0018-4000-a000-000000000018', product_id=18, quantity=1 |

Keycloak: `id=aaaaaaaa-0018-4000-a000-000000000018, username=cart_kim, email=cart_kim@test.com, role=CUSTOMER`

---

### Scenario 19 — Nguyen Duc Tuan has bluetooth speaker in cart

Nguyen Duc Tuan from Nha Trang has JBL Flip 6 Teal (product_id=19, qty=1) in cart for beach trip.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| cart | cart_item | customer_id='aaaaaaaa-0019-4000-a000-000000000019', product_id=19, quantity=1 |

Keycloak: `id=aaaaaaaa-0019-4000-a000-000000000019, username=cart_tuan, email=cart_tuan@test.com, role=CUSTOMER`

---

### Scenario 20 — Le Van Hai has 3 succulents in cart

Le Van Hai from Vung Tau has 3 Haworthia Cooperi pots (product_id=20, qty=3) for balcony decor.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| cart | cart_item | customer_id='aaaaaaaa-0020-4000-a000-000000000020', product_id=20, quantity=3 |

Keycloak: `id=aaaaaaaa-0020-4000-a000-000000000020, username=cart_hai, email=cart_hai@test.com, role=CUSTOMER`

---

### Scenario 21 — Dinh Thi Huyen has rice cooker in cart

Dinh Thi Huyen from Hanoi has Cuckoo CRP-P0609S Silver (product_id=21, qty=1) in cart as a wedding gift.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| cart | cart_item | customer_id='aaaaaaaa-0021-4000-a000-000000000021', product_id=21, quantity=1 |

Keycloak: `id=aaaaaaaa-0021-4000-a000-000000000021, username=cart_huyen, email=cart_huyen@test.com, role=CUSTOMER`

---

### Scenario 22 — Ngo Van Cuong has fishing combo in cart

Ngo Van Cuong from Can Tho has Shimano Sienna FE 2500 combo (product_id=22, qty=1) in cart.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| cart | cart_item | customer_id='aaaaaaaa-0022-4000-a000-000000000022', product_id=22, quantity=1 |

Keycloak: `id=aaaaaaaa-0022-4000-a000-000000000022, username=cart_cuong2, email=cart_cuong2@test.com, role=CUSTOMER`

---

### Scenario 23 — Pham Thi Mai has 2 toners in cart

Pham Thi Mai from Da Nang has 2 COSRX AHA/BHA Toners (product_id=23, qty=2) in cart.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| cart | cart_item | customer_id='aaaaaaaa-0023-4000-a000-000000000023', product_id=23, quantity=2 |

Keycloak: `id=aaaaaaaa-0023-4000-a000-000000000023, username=cart_mai, email=cart_mai@test.com, role=CUSTOMER`

---

### Scenario 24 — Tran Duc Khanh has watch charger in cart

Tran Duc Khanh from Ho Chi Minh City has Garmin FR255 charging cable (product_id=24, qty=1) in cart.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| cart | cart_item | customer_id='aaaaaaaa-0024-4000-a000-000000000024', product_id=24, quantity=1 |

Keycloak: `id=aaaaaaaa-0024-4000-a000-000000000024, username=cart_khanh, email=cart_khanh@test.com, role=CUSTOMER`

---

### Scenario 25 — Bui Thi Lan has frying pan in cart

Bui Thi Lan from Hai Phong has Tefal Easy Cook 28cm Red (product_id=25, qty=1) in cart.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| cart | cart_item | customer_id='aaaaaaaa-0025-4000-a000-000000000025', product_id=25, quantity=1 |

Keycloak: `id=aaaaaaaa-0025-4000-a000-000000000025, username=cart_lan2, email=cart_lan2@test.com, role=CUSTOMER`

---

### Scenario 26 — Hoang Van Binh has polo shirt in cart

Hoang Van Binh from Hanoi has Lacoste Classic Polo Navy M (product_id=26, qty=1) in cart.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| cart | cart_item | customer_id='aaaaaaaa-0026-4000-a000-000000000026', product_id=26, quantity=1 |

Keycloak: `id=aaaaaaaa-0026-4000-a000-000000000026, username=cart_binh, email=cart_binh@test.com, role=CUSTOMER`

---

### Scenario 27 — Nguyen Thi Thanh Thuy has kids bike in cart

Nguyen Thi Thanh Thuy from Ho Chi Minh City has Giant ARX 20 Blue (product_id=27, qty=1) in cart for son's birthday.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| cart | cart_item | customer_id='aaaaaaaa-0027-4000-a000-000000000027', product_id=27, quantity=1 |

Keycloak: `id=aaaaaaaa-0027-4000-a000-000000000027, username=cart_thuy, email=cart_thuy@test.com, role=CUSTOMER`

---

### Scenario 28 — Le Hoang Nam has power bank in cart

Le Hoang Nam from Da Nang has Anker PowerCore 20000mAh (product_id=28, qty=1) in cart.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| cart | cart_item | customer_id='aaaaaaaa-0028-4000-a000-000000000028', product_id=28, quantity=1 |

Keycloak: `id=aaaaaaaa-0028-4000-a000-000000000028, username=cart_nam, email=cart_nam@test.com, role=CUSTOMER`

---

### Scenario 29 — Tran Thi Quynh has puzzle in cart

Tran Thi Quynh from Hue has Ravensburger Hoi An 1000-piece (product_id=29, qty=1) in cart.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| cart | cart_item | customer_id='aaaaaaaa-0029-4000-a000-000000000029', product_id=29, quantity=1 |

Keycloak: `id=aaaaaaaa-0029-4000-a000-000000000029, username=cart_quynh, email=cart_quynh@test.com, role=CUSTOMER`

---

### Scenario 30 — Vu Thi Thu Hang has perfume in cart

Vu Thi Thu Hang from Ho Chi Minh City has Chanel Chance Tendre 50ml (product_id=30, qty=1) in cart.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| cart | cart_item | customer_id='aaaaaaaa-0030-4000-a000-000000000030', product_id=30, quantity=1 |

Keycloak: `id=aaaaaaaa-0030-4000-a000-000000000030, username=cart_hang, email=cart_hang@test.com, role=CUSTOMER`

---

### Scenario 31 — Nguyen Van Hieu has router in cart

Nguyen Van Hieu from Hanoi has TP-Link Archer AX73 (product_id=31, qty=1) in cart.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| cart | cart_item | customer_id='aaaaaaaa-0031-4000-a000-000000000031', product_id=31, quantity=1 |

Keycloak: `id=aaaaaaaa-0031-4000-a000-000000000031, username=cart_hieu, email=cart_hieu@test.com, role=CUSTOMER`

---

### Scenario 32 — Trinh Thi Nga has 3 essential oil bottles in cart

Trinh Thi Nga from Nha Trang has 3 Plant Therapy Lavender 30ml (product_id=32, qty=3) in cart.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| cart | cart_item | customer_id='aaaaaaaa-0032-4000-a000-000000000032', product_id=32, quantity=3 |

Keycloak: `id=aaaaaaaa-0032-4000-a000-000000000032, username=cart_nga2, email=cart_nga2@test.com, role=CUSTOMER`

---

### Scenario 33 — Pham Van Tung has whey protein in cart

Pham Van Tung from Ho Chi Minh City has ON Gold Standard Whey 2lb (product_id=33, qty=1) in cart.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| cart | cart_item | customer_id='aaaaaaaa-0033-4000-a000-000000000033', product_id=33, quantity=1 |

Keycloak: `id=aaaaaaaa-0033-4000-a000-000000000033, username=cart_tung, email=cart_tung@test.com, role=CUSTOMER`

---

### Scenario 34 — Hoang Thi Bao Ngoc has planner in cart

Hoang Thi Bao Ngoc from Da Lat has Hobonichi Techo A6 2025 (product_id=34, qty=1) in cart.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| cart | cart_item | customer_id='aaaaaaaa-0034-4000-a000-000000000034', product_id=34, quantity=1 |

Keycloak: `id=aaaaaaaa-0034-4000-a000-000000000034, username=cart_ngoc, email=cart_ngoc@test.com, role=CUSTOMER`

---

### Scenario 35 — Nguyen Thi Diem has 4 sunscreen tubes in cart

Nguyen Thi Diem from Hoi An has 4 Anessa Perfect UV SPF50+ (product_id=35, qty=4) in cart.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| cart | cart_item | customer_id='aaaaaaaa-0035-4000-a000-000000000035', product_id=35, quantity=4 |

Keycloak: `id=aaaaaaaa-0035-4000-a000-000000000035, username=cart_diem, email=cart_diem@test.com, role=CUSTOMER`

---

### Scenario 36 — Dao Van Kien has phone case in cart

Dao Van Kien from Bien Hoa has Spigen Ultra Hybrid iPhone 15 Pro Crystal (product_id=36, qty=1) in cart.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| cart | cart_item | customer_id='aaaaaaaa-0036-4000-a000-000000000036', product_id=36, quantity=1 |

Keycloak: `id=aaaaaaaa-0036-4000-a000-000000000036, username=cart_kien, email=cart_kien@test.com, role=CUSTOMER`

---

### Scenario 37 — Luong Thi Thao has hair dryer in cart

Luong Thi Thao from Ho Chi Minh City has Dyson Supersonic Fuchsia/Gold (product_id=37, qty=1) in cart.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| cart | cart_item | customer_id='aaaaaaaa-0037-4000-a000-000000000037', product_id=37, quantity=1 |

Keycloak: `id=aaaaaaaa-0037-4000-a000-000000000037, username=cart_thao, email=cart_thao@test.com, role=CUSTOMER`

---

### Scenario 38 — Do Van Thanh has travel pillow in cart

Do Van Thanh from Hanoi has Trtl Travel Pillow Plus Navy (product_id=38, qty=1) in cart.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| cart | cart_item | customer_id='aaaaaaaa-0038-4000-a000-000000000038', product_id=38, quantity=1 |

Keycloak: `id=aaaaaaaa-0038-4000-a000-000000000038, username=cart_thanh2, email=cart_thanh2@test.com, role=CUSTOMER`

---

### Scenario 39 — Nguyen Thi Hong has waffle maker in cart

Nguyen Thi Hong from Can Tho has Cuisinart WMB-4 Stainless (product_id=39, qty=1) in cart.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| cart | cart_item | customer_id='aaaaaaaa-0039-4000-a000-000000000039', product_id=39, quantity=1 |

Keycloak: `id=aaaaaaaa-0039-4000-a000-000000000039, username=cart_hong, email=cart_hong@test.com, role=CUSTOMER`

---

### Scenario 40 — Tran Quoc Bao has drawing tablet in cart

Tran Quoc Bao from Ho Chi Minh City has Wacom Intuos Small Wireless Black (product_id=40, qty=1) in cart.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| cart | cart_item | customer_id='aaaaaaaa-0040-4000-a000-000000000040', product_id=40, quantity=1 |

Keycloak: `id=aaaaaaaa-0040-4000-a000-000000000040, username=cart_bao, email=cart_bao@test.com, role=CUSTOMER`

---

### Scenario 41 — Ly Thi Cam has 3 baby formula cans in cart

Ly Thi Cam from Hai Phong has 3 Enfamil NeuroPro 865g (product_id=41, qty=3) in cart.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| cart | cart_item | customer_id='aaaaaaaa-0041-4000-a000-000000000041', product_id=41, quantity=3 |

Keycloak: `id=aaaaaaaa-0041-4000-a000-000000000041, username=cart_cam, email=cart_cam@test.com, role=CUSTOMER`

---

### Scenario 42 — Nguyen Van Khanh has dartboard in cart

Nguyen Van Khanh from Vung Tau has Winmau Blade 6 Black (product_id=42, qty=1) in cart.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| cart | cart_item | customer_id='aaaaaaaa-0042-4000-a000-000000000042', product_id=42, quantity=1 |

Keycloak: `id=aaaaaaaa-0042-4000-a000-000000000042, username=cart_khanh2, email=cart_khanh2@test.com, role=CUSTOMER`

---

### Scenario 43 — Phan Thi My Hanh has 5 containers in cart

Phan Thi My Hanh from Da Nang has 5 Sistema Brilliance 1.6L Clear (product_id=43, qty=5) in cart for meal prep.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| cart | cart_item | customer_id='aaaaaaaa-0043-4000-a000-000000000043', product_id=43, quantity=5 |

Keycloak: `id=aaaaaaaa-0043-4000-a000-000000000043, username=cart_hanh, email=cart_hanh@test.com, role=CUSTOMER`

---

### Scenario 44 — Cao Minh Duc has earbuds in cart

Cao Minh Duc from Ho Chi Minh City has Sony WF-1000XM5 Black (product_id=44, qty=1) in cart.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| cart | cart_item | customer_id='aaaaaaaa-0044-4000-a000-000000000044', product_id=44, quantity=1 |

Keycloak: `id=aaaaaaaa-0044-4000-a000-000000000044, username=cart_duc2, email=cart_duc2@test.com, role=CUSTOMER`

---

### Scenario 45 — Nguyen Thi Nhu Quynh has water bottle in cart

Nguyen Thi Nhu Quynh from Hue has Hydro Flask 32oz Flamingo Pink (product_id=45, qty=1) in cart.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| cart | cart_item | customer_id='aaaaaaaa-0045-4000-a000-000000000045', product_id=45, quantity=1 |

Keycloak: `id=aaaaaaaa-0045-4000-a000-000000000045, username=cart_quynh2, email=cart_quynh2@test.com, role=CUSTOMER`

---

### Scenario 46 — Vo Ngoc Tuan has projector in cart

Vo Ngoc Tuan from Hanoi has Anker Nebula Capsule II Black (product_id=46, qty=1) in cart.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| cart | cart_item | customer_id='aaaaaaaa-0046-4000-a000-000000000046', product_id=46, quantity=1 |

Keycloak: `id=aaaaaaaa-0046-4000-a000-000000000046, username=cart_tuan2, email=cart_tuan2@test.com, role=CUSTOMER`

---

### Scenario 47 — Bui Thi Thu Huong has electric toothbrush in cart

Bui Thi Thu Huong from Ho Chi Minh City has Oral-B iO Series 7 Onyx (product_id=47, qty=1) in cart.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| cart | cart_item | customer_id='aaaaaaaa-0047-4000-a000-000000000047', product_id=47, quantity=1 |

Keycloak: `id=aaaaaaaa-0047-4000-a000-000000000047, username=cart_huong, email=cart_huong@test.com, role=CUSTOMER`

---

### Scenario 48 — Le Thi Xuan Mai has 2 cookbooks in cart

Le Thi Xuan Mai from Da Nang has 2 Bếp Việt Miền Trung hardcover (product_id=48, qty=2) in cart.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| cart | cart_item | customer_id='aaaaaaaa-0048-4000-a000-000000000048', product_id=48, quantity=2 |

Keycloak: `id=aaaaaaaa-0048-4000-a000-000000000048, username=cart_xmai, email=cart_xmai@test.com, role=CUSTOMER`

---

### Scenario 49 — Nguyen Thanh Phong has car mount in cart

Nguyen Thanh Phong from Bien Hoa has Spigen GTS300 MagSafe (product_id=49, qty=1) in cart.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| cart | cart_item | customer_id='aaaaaaaa-0049-4000-a000-000000000049', product_id=49, quantity=1 |

Keycloak: `id=aaaaaaaa-0049-4000-a000-000000000049, username=cart_phong, email=cart_phong@test.com, role=CUSTOMER`

---

### Scenario 50 — Tran Thi My Linh has scented candle in cart

Tran Thi My Linh from Hanoi has Diptyque Baies 190g (product_id=50, qty=1) in cart.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| cart | cart_item | customer_id='aaaaaaaa-0050-4000-a000-000000000050', product_id=50, quantity=1 |

Keycloak: `id=aaaaaaaa-0050-4000-a000-000000000050, username=cart_linh, email=cart_linh@test.com, role=CUSTOMER`

---

## Data State: customer_with_address

*Enables flows: customer_create_address_customer_success, customer_get_addresses_customer_success, customer_get_default_address_customer_success, customer_delete_address_customer_success, customer_set_default_address_customer_success, customer_list_admin_success*

*UUID pattern: `bbbbbbbb-00NN-4000-a000-000000000NNN` (N=01..50)*

*Shared location seed (insert once):*
- `location.country` id=1, name='Việt Nam', code='VN'
- `location.state_or_province` id=1..10 (Hà Nội, TP.HCM, Đà Nẵng, Hải Phòng, Cần Thơ, Huế, Nha Trang, Đà Lạt, Vũng Tàu, Biên Hòa)
- `location.district` id=1..20 (districts rotating across provinces — see table below)

| province_id | province_name | districts |
|-------------|---------------|-----------|
| 1 | Hà Nội | id=1 Hoàn Kiếm, id=2 Đống Đa |
| 2 | TP.HCM | id=3 Quận 1, id=4 Quận 3 |
| 3 | Đà Nẵng | id=5 Hải Châu, id=6 Sơn Trà |
| 4 | Hải Phòng | id=7 Lê Chân, id=8 Ngô Quyền |
| 5 | Cần Thơ | id=9 Ninh Kiều, id=10 Bình Thủy |
| 6 | Huế | id=11 Phú Hội, id=12 Vĩnh Ninh |
| 7 | Nha Trang | id=13 Lộc Thọ, id=14 Phước Hải |
| 8 | Đà Lạt | id=15 Phường 1, id=16 Phường 4 |
| 9 | Vũng Tàu | id=17 Phường 1, id=18 Thắng Tam |
| 10 | Biên Hòa | id=19 Tân Phong, id=20 Trảng Dài |

---

### Scenario 1 — Nguyen Thi Lan's Hanoi address

Nguyen Thi Lan lives at 12 Phố Lý Thường Kiệt, Hoàn Kiếm, Hà Nội. First address in system, set as default.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=1, user_id='bbbbbbbb-0001-4000-a000-000000000001', phone='0901234501', address_line='12 Phố Lý Thường Kiệt', city='Hà Nội', district_id=1, state_id=1, country_id=1, is_default=true |

Keycloak: `id=bbbbbbbb-0001-4000-a000-000000000001, username=addr_lan, email=addr_lan@test.com, role=CUSTOMER`

---

### Scenario 2 — Tran Van Minh's HCMC address

Tran Van Minh lives at 45 Đường Nguyễn Huệ, Quận 1, TP.HCM. Default address.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=2, user_id='bbbbbbbb-0002-4000-a000-000000000002', phone='0901234502', address_line='45 Đường Nguyễn Huệ', city='TP. Hồ Chí Minh', district_id=3, state_id=2, country_id=1, is_default=true |

Keycloak: `id=bbbbbbbb-0002-4000-a000-000000000002, username=addr_minh, email=addr_minh@test.com, role=CUSTOMER`

---

### Scenario 3 — Le Thi Hoa's Da Nang address

Le Thi Hoa lives at 78 Bạch Đằng, Hải Châu, Đà Nẵng. Default address.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=3, user_id='bbbbbbbb-0003-4000-a000-000000000003', phone='0901234503', address_line='78 Đường Bạch Đằng', city='Đà Nẵng', district_id=5, state_id=3, country_id=1, is_default=true |

Keycloak: `id=bbbbbbbb-0003-4000-a000-000000000003, username=addr_hoa, email=addr_hoa@test.com, role=CUSTOMER`

---

### Scenario 4 — Pham Duc Hung's Hai Phong address

Pham Duc Hung lives at 23 Phố Điện Biên Phủ, Lê Chân, Hải Phòng. Default address.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=4, user_id='bbbbbbbb-0004-4000-a000-000000000004', phone='0901234504', address_line='23 Phố Điện Biên Phủ', city='Hải Phòng', district_id=7, state_id=4, country_id=1, is_default=true |

Keycloak: `id=bbbbbbbb-0004-4000-a000-000000000004, username=addr_hung, email=addr_hung@test.com, role=CUSTOMER`

---

### Scenario 5 — Hoang Thi Thu's Can Tho address

Hoang Thi Thu lives at 56 Đường 3/2, Ninh Kiều, Cần Thơ. Default address.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=5, user_id='bbbbbbbb-0005-4000-a000-000000000005', phone='0901234505', address_line='56 Đường 3/2', city='Cần Thơ', district_id=9, state_id=5, country_id=1, is_default=true |

Keycloak: `id=bbbbbbbb-0005-4000-a000-000000000005, username=addr_thu, email=addr_thu@test.com, role=CUSTOMER`

---

### Scenario 6 — Vo Van Thanh's Hue address

Vo Van Thanh lives at 34 Đường Lê Lợi, Phú Hội, Huế. Default address.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=6, user_id='bbbbbbbb-0006-4000-a000-000000000006', phone='0901234506', address_line='34 Đường Lê Lợi', city='Huế', district_id=11, state_id=6, country_id=1, is_default=true |

Keycloak: `id=bbbbbbbb-0006-4000-a000-000000000006, username=addr_thanh, email=addr_thanh@test.com, role=CUSTOMER`

---

### Scenario 7 — Nguyen Thi Bich's Nha Trang address

Nguyen Thi Bich lives at 90 Trần Phú, Lộc Thọ, Nha Trang. Default address.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=7, user_id='bbbbbbbb-0007-4000-a000-000000000007', phone='0901234507', address_line='90 Đường Trần Phú', city='Nha Trang', district_id=13, state_id=7, country_id=1, is_default=true |

Keycloak: `id=bbbbbbbb-0007-4000-a000-000000000007, username=addr_bich, email=addr_bich@test.com, role=CUSTOMER`

---

### Scenario 8 — Do Manh Cuong's Da Lat address

Do Manh Cuong lives at 15 Đường Trần Hưng Đạo, Phường 1, Đà Lạt. Default address.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=8, user_id='bbbbbbbb-0008-4000-a000-000000000008', phone='0901234508', address_line='15 Đường Trần Hưng Đạo', city='Đà Lạt', district_id=15, state_id=8, country_id=1, is_default=true |

Keycloak: `id=bbbbbbbb-0008-4000-a000-000000000008, username=addr_cuong, email=addr_cuong@test.com, role=CUSTOMER`

---

### Scenario 9 — Tran Thi Oanh's Vung Tau address

Tran Thi Oanh lives at 67 Đường Thùy Vân, Phường 1, Vũng Tàu. Default address.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=9, user_id='bbbbbbbb-0009-4000-a000-000000000009', phone='0901234509', address_line='67 Đường Thùy Vân', city='Vũng Tàu', district_id=17, state_id=9, country_id=1, is_default=true |

Keycloak: `id=bbbbbbbb-0009-4000-a000-000000000009, username=addr_oanh, email=addr_oanh@test.com, role=CUSTOMER`

---

### Scenario 10 — Bui Van Duc's Bien Hoa address

Bui Van Duc lives at 88 Đường Đồng Khởi, Tân Phong, Biên Hòa. Default address.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=10, user_id='bbbbbbbb-0010-4000-a000-000000000010', phone='0901234510', address_line='88 Đường Đồng Khởi', city='Biên Hòa', district_id=19, state_id=10, country_id=1, is_default=true |

Keycloak: `id=bbbbbbbb-0010-4000-a000-000000000010, username=addr_duc, email=addr_duc@test.com, role=CUSTOMER`

---

### Scenario 11 — Ly Thi Phuong's Dong Da address

Ly Thi Phuong lives at 5 Phố Chùa Láng, Đống Đa, Hà Nội. Default address.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=11, user_id='bbbbbbbb-0011-4000-a000-000000000011', phone='0901234511', address_line='5 Phố Chùa Láng', city='Hà Nội', district_id=2, state_id=1, country_id=1, is_default=true |

Keycloak: `id=bbbbbbbb-0011-4000-a000-000000000011, username=addr_phuong, email=addr_phuong@test.com, role=CUSTOMER`

---

### Scenario 12 — Nguyen Van An's Q3 HCMC address

Nguyen Van An lives at 101 Đường Võ Thị Sáu, Quận 3, TP.HCM. Default address.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=12, user_id='bbbbbbbb-0012-4000-a000-000000000012', phone='0901234512', address_line='101 Đường Võ Thị Sáu', city='TP. Hồ Chí Minh', district_id=4, state_id=2, country_id=1, is_default=true |

Keycloak: `id=bbbbbbbb-0012-4000-a000-000000000012, username=addr_an, email=addr_an@test.com, role=CUSTOMER`

---

### Scenario 13 — Dang Thi Lien's Son Tra address

Dang Thi Lien lives at 32 Đường Phạm Văn Đồng, Sơn Trà, Đà Nẵng. Default address.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=13, user_id='bbbbbbbb-0013-4000-a000-000000000013', phone='0901234513', address_line='32 Đường Phạm Văn Đồng', city='Đà Nẵng', district_id=6, state_id=3, country_id=1, is_default=true |

Keycloak: `id=bbbbbbbb-0013-4000-a000-000000000013, username=addr_lien, email=addr_lien@test.com, role=CUSTOMER`

---

### Scenario 14 — Phan Thi Xuan's Ngo Quyen address

Phan Thi Xuan lives at 44 Phố Lý Tự Trọng, Ngô Quyền, Hải Phòng. Default address.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=14, user_id='bbbbbbbb-0014-4000-a000-000000000014', phone='0901234514', address_line='44 Phố Lý Tự Trọng', city='Hải Phòng', district_id=8, state_id=4, country_id=1, is_default=true |

Keycloak: `id=bbbbbbbb-0014-4000-a000-000000000014, username=addr_xuan, email=addr_xuan@test.com, role=CUSTOMER`

---

### Scenario 15 — Truong Van Long's Binh Thuy address

Truong Van Long lives at 19 Đường Nguyễn Văn Cừ, Bình Thủy, Cần Thơ. Default address.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=15, user_id='bbbbbbbb-0015-4000-a000-000000000015', phone='0901234515', address_line='19 Đường Nguyễn Văn Cừ', city='Cần Thơ', district_id=10, state_id=5, country_id=1, is_default=true |

Keycloak: `id=bbbbbbbb-0015-4000-a000-000000000015, username=addr_long, email=addr_long@test.com, role=CUSTOMER`

---

### Scenario 16 — Cao Thi Nga's Vinh Ninh address

Cao Thi Nga lives at 7 Đường Hai Bà Trưng, Vĩnh Ninh, Huế. Default address.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=16, user_id='bbbbbbbb-0016-4000-a000-000000000016', phone='0901234516', address_line='7 Đường Hai Bà Trưng', city='Huế', district_id=12, state_id=6, country_id=1, is_default=true |

Keycloak: `id=bbbbbbbb-0016-4000-a000-000000000016, username=addr_nga, email=addr_nga@test.com, role=CUSTOMER`

---

### Scenario 17 — Mai Van Son's Phuoc Hai address

Mai Van Son lives at 25 Đường Nguyễn Thiện Thuật, Phước Hải, Nha Trang. Default address.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=17, user_id='bbbbbbbb-0017-4000-a000-000000000017', phone='0901234517', address_line='25 Đường Nguyễn Thiện Thuật', city='Nha Trang', district_id=14, state_id=7, country_id=1, is_default=true |

Keycloak: `id=bbbbbbbb-0017-4000-a000-000000000017, username=addr_son, email=addr_son@test.com, role=CUSTOMER`

---

### Scenario 18 — Vo Thi Kim's Da Lat Phuong 4 address

Vo Thi Kim lives at 38 Đường Phan Đình Phùng, Phường 4, Đà Lạt. Default address.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=18, user_id='bbbbbbbb-0018-4000-a000-000000000018', phone='0901234518', address_line='38 Đường Phan Đình Phùng', city='Đà Lạt', district_id=16, state_id=8, country_id=1, is_default=true |

Keycloak: `id=bbbbbbbb-0018-4000-a000-000000000018, username=addr_kim, email=addr_kim@test.com, role=CUSTOMER`

---

### Scenario 19 — Nguyen Duc Tuan's Thang Tam address

Nguyen Duc Tuan lives at 52 Đường Nam Kỳ Khởi Nghĩa, Thắng Tam, Vũng Tàu. Default address.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=19, user_id='bbbbbbbb-0019-4000-a000-000000000019', phone='0901234519', address_line='52 Đường Nam Kỳ Khởi Nghĩa', city='Vũng Tàu', district_id=18, state_id=9, country_id=1, is_default=true |

Keycloak: `id=bbbbbbbb-0019-4000-a000-000000000019, username=addr_tuan, email=addr_tuan@test.com, role=CUSTOMER`

---

### Scenario 20 — Le Van Hai's Trang Dai address

Le Van Hai lives at 77 Đường Cách Mạng Tháng 8, Trảng Dài, Biên Hòa. Default address.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=20, user_id='bbbbbbbb-0020-4000-a000-000000000020', phone='0901234520', address_line='77 Đường Cách Mạng Tháng 8', city='Biên Hòa', district_id=20, state_id=10, country_id=1, is_default=true |

Keycloak: `id=bbbbbbbb-0020-4000-a000-000000000020, username=addr_hai, email=addr_hai@test.com, role=CUSTOMER`

---

### Scenario 21 — Dinh Thi Huyen — Hanoi Hoan Kiem, 2nd address

Dinh Thi Huyen has primary address at 3 Đinh Tiên Hoàng, Hoàn Kiếm and a secondary at 11 Hàng Bài, Hoàn Kiếm. Default is first.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=21, user_id='bbbbbbbb-0021-4000-a000-000000000021', phone='0901234521', address_line='3 Đinh Tiên Hoàng', city='Hà Nội', district_id=1, state_id=1, country_id=1, is_default=true |
| customer | user_address | id=22, user_id='bbbbbbbb-0021-4000-a000-000000000021', phone='0901234521', address_line='11 Hàng Bài', city='Hà Nội', district_id=1, state_id=1, country_id=1, is_default=false |

Keycloak: `id=bbbbbbbb-0021-4000-a000-000000000021, username=addr_huyen, email=addr_huyen@test.com, role=CUSTOMER`

---

### Scenario 22 — Ngo Van Cuong's Q1 HCMC address

Ngo Van Cuong lives at 200 Đường Lý Chính Thắng, Quận 1, TP.HCM. Default address.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=23, user_id='bbbbbbbb-0022-4000-a000-000000000022', phone='0901234522', address_line='200 Đường Lý Chính Thắng', city='TP. Hồ Chí Minh', district_id=3, state_id=2, country_id=1, is_default=true |

Keycloak: `id=bbbbbbbb-0022-4000-a000-000000000022, username=addr_cuong2, email=addr_cuong2@test.com, role=CUSTOMER`

---

### Scenario 23 — Pham Thi Mai's Hai Chau address

Pham Thi Mai lives at 16 Trần Phú, Hải Châu, Đà Nẵng. Default address.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=24, user_id='bbbbbbbb-0023-4000-a000-000000000023', phone='0901234523', address_line='16 Đường Trần Phú', city='Đà Nẵng', district_id=5, state_id=3, country_id=1, is_default=true |

Keycloak: `id=bbbbbbbb-0023-4000-a000-000000000023, username=addr_mai, email=addr_mai@test.com, role=CUSTOMER`

---

### Scenario 24 — Tran Duc Khanh's Le Chan address

Tran Duc Khanh lives at 60 Đường Tô Hiệu, Lê Chân, Hải Phòng. Default address.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=25, user_id='bbbbbbbb-0024-4000-a000-000000000024', phone='0901234524', address_line='60 Đường Tô Hiệu', city='Hải Phòng', district_id=7, state_id=4, country_id=1, is_default=true |

Keycloak: `id=bbbbbbbb-0024-4000-a000-000000000024, username=addr_khanh, email=addr_khanh@test.com, role=CUSTOMER`

---

### Scenario 25 — Bui Thi Lan's Ninh Kieu address

Bui Thi Lan lives at 9 Đường Hoà Bình, Ninh Kiều, Cần Thơ. Default address.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=26, user_id='bbbbbbbb-0025-4000-a000-000000000025', phone='0901234525', address_line='9 Đường Hoà Bình', city='Cần Thơ', district_id=9, state_id=5, country_id=1, is_default=true |

Keycloak: `id=bbbbbbbb-0025-4000-a000-000000000025, username=addr_lan2, email=addr_lan2@test.com, role=CUSTOMER`

---

### Scenario 26 — Hoang Van Binh's Phu Hoi Hue address

Hoang Van Binh lives at 41 Đường Nguyễn Trãi, Phú Hội, Huế. Default address.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=27, user_id='bbbbbbbb-0026-4000-a000-000000000026', phone='0901234526', address_line='41 Đường Nguyễn Trãi', city='Huế', district_id=11, state_id=6, country_id=1, is_default=true |

Keycloak: `id=bbbbbbbb-0026-4000-a000-000000000026, username=addr_binh, email=addr_binh@test.com, role=CUSTOMER`

---

### Scenario 27 — Nguyen Thi Thanh Thuy's Loc Tho address

Nguyen Thi Thanh Thuy lives at 73 Đường Nguyễn Đình Chiểu, Lộc Thọ, Nha Trang. Default address.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=28, user_id='bbbbbbbb-0027-4000-a000-000000000027', phone='0901234527', address_line='73 Đường Nguyễn Đình Chiểu', city='Nha Trang', district_id=13, state_id=7, country_id=1, is_default=true |

Keycloak: `id=bbbbbbbb-0027-4000-a000-000000000027, username=addr_thuy, email=addr_thuy@test.com, role=CUSTOMER`

---

### Scenario 28 — Le Hoang Nam's Phuong 1 Da Lat address

Le Hoang Nam lives at 22 Đường Đinh Tiên Hoàng, Phường 1, Đà Lạt. Default address.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=29, user_id='bbbbbbbb-0028-4000-a000-000000000028', phone='0901234528', address_line='22 Đường Đinh Tiên Hoàng', city='Đà Lạt', district_id=15, state_id=8, country_id=1, is_default=true |

Keycloak: `id=bbbbbbbb-0028-4000-a000-000000000028, username=addr_nam, email=addr_nam@test.com, role=CUSTOMER`

---

### Scenario 29 — Tran Thi Quynh's Phuong 1 Vung Tau address

Tran Thi Quynh lives at 85 Đường Lý Thường Kiệt, Phường 1, Vũng Tàu. Default address.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=30, user_id='bbbbbbbb-0029-4000-a000-000000000029', phone='0901234529', address_line='85 Đường Lý Thường Kiệt', city='Vũng Tàu', district_id=17, state_id=9, country_id=1, is_default=true |

Keycloak: `id=bbbbbbbb-0029-4000-a000-000000000029, username=addr_quynh, email=addr_quynh@test.com, role=CUSTOMER`

---

### Scenario 30 — Vu Thi Thu Hang's Tan Phong address

Vu Thi Thu Hang lives at 14 Đường Phạm Văn Thuận, Tân Phong, Biên Hòa. Default address.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=31, user_id='bbbbbbbb-0030-4000-a000-000000000030', phone='0901234530', address_line='14 Đường Phạm Văn Thuận', city='Biên Hòa', district_id=19, state_id=10, country_id=1, is_default=true |

Keycloak: `id=bbbbbbbb-0030-4000-a000-000000000030, username=addr_hang, email=addr_hang@test.com, role=CUSTOMER`

---

### Scenario 31 — Nguyen Van Hieu's Dong Da address

Nguyen Van Hieu lives at 91 Phố Khâm Thiên, Đống Đa, Hà Nội. Default address.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=32, user_id='bbbbbbbb-0031-4000-a000-000000000031', phone='0901234531', address_line='91 Phố Khâm Thiên', city='Hà Nội', district_id=2, state_id=1, country_id=1, is_default=true |

Keycloak: `id=bbbbbbbb-0031-4000-a000-000000000031, username=addr_hieu, email=addr_hieu@test.com, role=CUSTOMER`

---

### Scenario 32 — Trinh Thi Nga's Q3 HCMC address

Trinh Thi Nga lives at 37 Đường Nam Kỳ Khởi Nghĩa, Quận 3, TP.HCM. Default address.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=33, user_id='bbbbbbbb-0032-4000-a000-000000000032', phone='0901234532', address_line='37 Đường Nam Kỳ Khởi Nghĩa', city='TP. Hồ Chí Minh', district_id=4, state_id=2, country_id=1, is_default=true |

Keycloak: `id=bbbbbbbb-0032-4000-a000-000000000032, username=addr_nga2, email=addr_nga2@test.com, role=CUSTOMER`

---

### Scenario 33 — Pham Van Tung's Son Tra address

Pham Van Tung lives at 55 Đường Võ Nguyên Giáp, Sơn Trà, Đà Nẵng. Default address.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=34, user_id='bbbbbbbb-0033-4000-a000-000000000033', phone='0901234533', address_line='55 Đường Võ Nguyên Giáp', city='Đà Nẵng', district_id=6, state_id=3, country_id=1, is_default=true |

Keycloak: `id=bbbbbbbb-0033-4000-a000-000000000033, username=addr_tung, email=addr_tung@test.com, role=CUSTOMER`

---

### Scenario 34 — Hoang Thi Bao Ngoc's Ngo Quyen address

Hoang Thi Bao Ngoc lives at 18 Phố Quang Trung, Ngô Quyền, Hải Phòng. Default address.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=35, user_id='bbbbbbbb-0034-4000-a000-000000000034', phone='0901234534', address_line='18 Phố Quang Trung', city='Hải Phòng', district_id=8, state_id=4, country_id=1, is_default=true |

Keycloak: `id=bbbbbbbb-0034-4000-a000-000000000034, username=addr_ngoc, email=addr_ngoc@test.com, role=CUSTOMER`

---

### Scenario 35 — Nguyen Thi Diem's Binh Thuy address

Nguyen Thi Diem lives at 63 Đường Mậu Thân, Bình Thủy, Cần Thơ. Default address.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=36, user_id='bbbbbbbb-0035-4000-a000-000000000035', phone='0901234535', address_line='63 Đường Mậu Thân', city='Cần Thơ', district_id=10, state_id=5, country_id=1, is_default=true |

Keycloak: `id=bbbbbbbb-0035-4000-a000-000000000035, username=addr_diem, email=addr_diem@test.com, role=CUSTOMER`

---

### Scenario 36 — Dao Van Kien's Vinh Ninh address

Dao Van Kien lives at 28 Đường Trần Cao Vân, Vĩnh Ninh, Huế. Default address.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=37, user_id='bbbbbbbb-0036-4000-a000-000000000036', phone='0901234536', address_line='28 Đường Trần Cao Vân', city='Huế', district_id=12, state_id=6, country_id=1, is_default=true |

Keycloak: `id=bbbbbbbb-0036-4000-a000-000000000036, username=addr_kien, email=addr_kien@test.com, role=CUSTOMER`

---

### Scenario 37 — Luong Thi Thao's Phuoc Hai address

Luong Thi Thao lives at 47 Đường Ngô Gia Tự, Phước Hải, Nha Trang. Default address.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=38, user_id='bbbbbbbb-0037-4000-a000-000000000037', phone='0901234537', address_line='47 Đường Ngô Gia Tự', city='Nha Trang', district_id=14, state_id=7, country_id=1, is_default=true |

Keycloak: `id=bbbbbbbb-0037-4000-a000-000000000037, username=addr_thao, email=addr_thao@test.com, role=CUSTOMER`

---

### Scenario 38 — Do Van Thanh's Phuong 4 Da Lat address

Do Van Thanh lives at 11 Đường Lý Tự Trọng, Phường 4, Đà Lạt. Default address.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=39, user_id='bbbbbbbb-0038-4000-a000-000000000038', phone='0901234538', address_line='11 Đường Lý Tự Trọng', city='Đà Lạt', district_id=16, state_id=8, country_id=1, is_default=true |

Keycloak: `id=bbbbbbbb-0038-4000-a000-000000000038, username=addr_thanh2, email=addr_thanh2@test.com, role=CUSTOMER`

---

### Scenario 39 — Nguyen Thi Hong's Thang Tam address

Nguyen Thi Hong lives at 99 Đường Lê Hồng Phong, Thắng Tam, Vũng Tàu. Default address.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=40, user_id='bbbbbbbb-0039-4000-a000-000000000039', phone='0901234539', address_line='99 Đường Lê Hồng Phong', city='Vũng Tàu', district_id=18, state_id=9, country_id=1, is_default=true |

Keycloak: `id=bbbbbbbb-0039-4000-a000-000000000039, username=addr_hong, email=addr_hong@test.com, role=CUSTOMER`

---

### Scenario 40 — Tran Quoc Bao's Trang Dai address

Tran Quoc Bao lives at 50 Đường Lê Duẩn, Trảng Dài, Biên Hòa. Default address.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=41, user_id='bbbbbbbb-0040-4000-a000-000000000040', phone='0901234540', address_line='50 Đường Lê Duẩn', city='Biên Hòa', district_id=20, state_id=10, country_id=1, is_default=true |

Keycloak: `id=bbbbbbbb-0040-4000-a000-000000000040, username=addr_bao, email=addr_bao@test.com, role=CUSTOMER`

---

### Scenario 41 — Ly Thi Cam's Hoan Kiem address

Ly Thi Cam lives at 6 Phố Hàng Đào, Hoàn Kiếm, Hà Nội. Default address.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=42, user_id='bbbbbbbb-0041-4000-a000-000000000041', phone='0901234541', address_line='6 Phố Hàng Đào', city='Hà Nội', district_id=1, state_id=1, country_id=1, is_default=true |

Keycloak: `id=bbbbbbbb-0041-4000-a000-000000000041, username=addr_cam, email=addr_cam@test.com, role=CUSTOMER`

---

### Scenario 42 — Nguyen Van Khanh's Q1 HCMC address

Nguyen Van Khanh lives at 300 Đường Đinh Tiên Hoàng, Quận 1, TP.HCM. Default address.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=43, user_id='bbbbbbbb-0042-4000-a000-000000000042', phone='0901234542', address_line='300 Đường Đinh Tiên Hoàng', city='TP. Hồ Chí Minh', district_id=3, state_id=2, country_id=1, is_default=true |

Keycloak: `id=bbbbbbbb-0042-4000-a000-000000000042, username=addr_khanh2, email=addr_khanh2@test.com, role=CUSTOMER`

---

### Scenario 43 — Phan Thi My Hanh's Hai Chau address

Phan Thi My Hanh lives at 48 Đường Hùng Vương, Hải Châu, Đà Nẵng. Default address.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=44, user_id='bbbbbbbb-0043-4000-a000-000000000043', phone='0901234543', address_line='48 Đường Hùng Vương', city='Đà Nẵng', district_id=5, state_id=3, country_id=1, is_default=true |

Keycloak: `id=bbbbbbbb-0043-4000-a000-000000000043, username=addr_hanh, email=addr_hanh@test.com, role=CUSTOMER`

---

### Scenario 44 — Cao Minh Duc's Le Chan address

Cao Minh Duc lives at 82 Đường Lê Thánh Tông, Lê Chân, Hải Phòng. Default address.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=45, user_id='bbbbbbbb-0044-4000-a000-000000000044', phone='0901234544', address_line='82 Đường Lê Thánh Tông', city='Hải Phòng', district_id=7, state_id=4, country_id=1, is_default=true |

Keycloak: `id=bbbbbbbb-0044-4000-a000-000000000044, username=addr_duc2, email=addr_duc2@test.com, role=CUSTOMER`

---

### Scenario 45 — Nguyen Thi Nhu Quynh's Ninh Kieu address

Nguyen Thi Nhu Quynh lives at 31 Đường Cần Thơ, Ninh Kiều, Cần Thơ. Default address.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=46, user_id='bbbbbbbb-0045-4000-a000-000000000045', phone='0901234545', address_line='31 Đường Cần Thơ', city='Cần Thơ', district_id=9, state_id=5, country_id=1, is_default=true |

Keycloak: `id=bbbbbbbb-0045-4000-a000-000000000045, username=addr_quynh2, email=addr_quynh2@test.com, role=CUSTOMER`

---

### Scenario 46 — Vo Ngoc Tuan's Phu Hoi address

Vo Ngoc Tuan lives at 58 Đường Phan Bội Châu, Phú Hội, Huế. Default address.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=47, user_id='bbbbbbbb-0046-4000-a000-000000000046', phone='0901234546', address_line='58 Đường Phan Bội Châu', city='Huế', district_id=11, state_id=6, country_id=1, is_default=true |

Keycloak: `id=bbbbbbbb-0046-4000-a000-000000000046, username=addr_tuan2, email=addr_tuan2@test.com, role=CUSTOMER`

---

### Scenario 47 — Bui Thi Thu Huong's Loc Tho address

Bui Thi Thu Huong lives at 4 Đường Bến Chợ, Lộc Thọ, Nha Trang. Default address.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=48, user_id='bbbbbbbb-0047-4000-a000-000000000047', phone='0901234547', address_line='4 Đường Bến Chợ', city='Nha Trang', district_id=13, state_id=7, country_id=1, is_default=true |

Keycloak: `id=bbbbbbbb-0047-4000-a000-000000000047, username=addr_huong, email=addr_huong@test.com, role=CUSTOMER`

---

### Scenario 48 — Le Thi Xuan Mai's Phuong 4 Da Lat address

Le Thi Xuan Mai lives at 66 Đường Trần Quốc Toản, Phường 4, Đà Lạt. Default address.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=49, user_id='bbbbbbbb-0048-4000-a000-000000000048', phone='0901234548', address_line='66 Đường Trần Quốc Toản', city='Đà Lạt', district_id=16, state_id=8, country_id=1, is_default=true |

Keycloak: `id=bbbbbbbb-0048-4000-a000-000000000048, username=addr_xmai, email=addr_xmai@test.com, role=CUSTOMER`

---

### Scenario 49 — Nguyen Thanh Phong's Phuong 1 Vung Tau address

Nguyen Thanh Phong lives at 102 Đường Hoàng Hoa Thám, Phường 1, Vũng Tàu. Default address.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=50, user_id='bbbbbbbb-0049-4000-a000-000000000049', phone='0901234549', address_line='102 Đường Hoàng Hoa Thám', city='Vũng Tàu', district_id=17, state_id=9, country_id=1, is_default=true |

Keycloak: `id=bbbbbbbb-0049-4000-a000-000000000049, username=addr_phong, email=addr_phong@test.com, role=CUSTOMER`

---

### Scenario 50 — Tran Thi My Linh's Trang Dai address

Tran Thi My Linh lives at 39 Đường Phạm Văn Thuận, Trảng Dài, Biên Hòa. Default address.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=51, user_id='bbbbbbbb-0050-4000-a000-000000000050', phone='0901234550', address_line='39 Đường Phạm Văn Thuận', city='Biên Hòa', district_id=20, state_id=10, country_id=1, is_default=true |

Keycloak: `id=bbbbbbbb-0050-4000-a000-000000000050, username=addr_linh, email=addr_linh@test.com, role=CUSTOMER`

---

## Data State: customer_with_order

*Enables flows: order_create_checkout_customer_success, order_get_checkout_customer_success, order_update_checkout_payment_method_success, order_create_order_customer_success, order_get_my_orders_customer_success, order_get_order_by_checkout_success, order_check_completed_success, order_list_admin_success*

*Depends on: product_catalog group (products 1–50), customer_with_address location seed (country 1, provinces 1–10, districts 1–20)*

*UUID pattern: `cccccccc-00NN-4000-a000-000000000NNN` (N=01..50)*
*user_address ids: 101..150 (this group); checkout ids: 1..50; order ids: 1..50*

---

### Scenario 1 — Nguyen Thi Lan orders ao dai

Nguyen Thi Lan orders 1 silk ao dai (product_id=1, 850000 VND). Checkout created, order placed, status COMPLETED.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=101, user_id='cccccccc-0001-4000-a000-000000000001', phone='0911234501', address_line='12 Phố Lý Thường Kiệt', city='Hà Nội', district_id=1, state_id=1, country_id=1, is_default=true |
| cart | cart_item | customer_id='cccccccc-0001-4000-a000-000000000001', product_id=1, quantity=1 |
| order | checkout | id=1, customer_id='cccccccc-0001-4000-a000-000000000001', email='order_lan@test.com', shipping_address_id=101, billing_address_id=101, total_amount=850000, payment_method='COD' |
| order | order | id=1, checkout_id=1, customer_id='cccccccc-0001-4000-a000-000000000001', total_amount=850000, order_status='COMPLETED' |

Keycloak: `id=cccccccc-0001-4000-a000-000000000001, username=order_lan, email=order_lan@test.com, role=CUSTOMER`

---

### Scenario 2 — Tran Van Minh orders running shoes

Tran Van Minh orders 1 Adidas Ultraboost (product_id=2, 3200000 VND). COMPLETED order.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=102, user_id='cccccccc-0002-4000-a000-000000000002', phone='0911234502', address_line='45 Đường Nguyễn Huệ', city='TP. Hồ Chí Minh', district_id=3, state_id=2, country_id=1, is_default=true |
| cart | cart_item | customer_id='cccccccc-0002-4000-a000-000000000002', product_id=2, quantity=1 |
| order | checkout | id=2, customer_id='cccccccc-0002-4000-a000-000000000002', email='order_minh@test.com', shipping_address_id=102, billing_address_id=102, total_amount=3200000, payment_method='COD' |
| order | order | id=2, checkout_id=2, customer_id='cccccccc-0002-4000-a000-000000000002', total_amount=3200000, order_status='COMPLETED' |

Keycloak: `id=cccccccc-0002-4000-a000-000000000002, username=order_minh, email=order_minh@test.com, role=CUSTOMER`

---

### Scenario 3 — Le Thi Hoa orders 2 tea sets

Le Thi Hoa orders 2 Bat Trang tea sets (product_id=3, 1040000 VND total). COMPLETED.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=103, user_id='cccccccc-0003-4000-a000-000000000003', phone='0911234503', address_line='78 Đường Bạch Đằng', city='Đà Nẵng', district_id=5, state_id=3, country_id=1, is_default=true |
| cart | cart_item | customer_id='cccccccc-0003-4000-a000-000000000003', product_id=3, quantity=2 |
| order | checkout | id=3, customer_id='cccccccc-0003-4000-a000-000000000003', email='order_hoa@test.com', shipping_address_id=103, billing_address_id=103, total_amount=1040000, payment_method='COD' |
| order | order | id=3, checkout_id=3, customer_id='cccccccc-0003-4000-a000-000000000003', total_amount=1040000, order_status='COMPLETED' |

Keycloak: `id=cccccccc-0003-4000-a000-000000000003, username=order_hoa, email=order_hoa@test.com, role=CUSTOMER`

---

### Scenario 4 — Pham Duc Hung orders backpack

Pham Duc Hung orders Samsonite Guardit 2.0 (product_id=4, 1890000 VND). COMPLETED.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=104, user_id='cccccccc-0004-4000-a000-000000000004', phone='0911234504', address_line='23 Phố Điện Biên Phủ', city='Hải Phòng', district_id=7, state_id=4, country_id=1, is_default=true |
| cart | cart_item | customer_id='cccccccc-0004-4000-a000-000000000004', product_id=4, quantity=1 |
| order | checkout | id=4, customer_id='cccccccc-0004-4000-a000-000000000004', email='order_hung@test.com', shipping_address_id=104, billing_address_id=104, total_amount=1890000, payment_method='COD' |
| order | order | id=4, checkout_id=4, customer_id='cccccccc-0004-4000-a000-000000000004', total_amount=1890000, order_status='COMPLETED' |

Keycloak: `id=cccccccc-0004-4000-a000-000000000004, username=order_hung, email=order_hung@test.com, role=CUSTOMER`

---

### Scenario 5 — Hoang Thi Thu orders 3 coffee bags

Hoang Thi Thu orders 3 Trung Nguyen Premium Blend (product_id=5, 435000 VND). COMPLETED.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=105, user_id='cccccccc-0005-4000-a000-000000000005', phone='0911234505', address_line='56 Đường 3/2', city='Cần Thơ', district_id=9, state_id=5, country_id=1, is_default=true |
| cart | cart_item | customer_id='cccccccc-0005-4000-a000-000000000005', product_id=5, quantity=3 |
| order | checkout | id=5, customer_id='cccccccc-0005-4000-a000-000000000005', email='order_thu@test.com', shipping_address_id=105, billing_address_id=105, total_amount=435000, payment_method='COD' |
| order | order | id=5, checkout_id=5, customer_id='cccccccc-0005-4000-a000-000000000005', total_amount=435000, order_status='COMPLETED' |

Keycloak: `id=cccccccc-0005-4000-a000-000000000005, username=order_thu, email=order_thu@test.com, role=CUSTOMER`

---

### Scenario 6 — Vo Van Thanh orders Apple Watch

Vo Van Thanh orders Apple Watch SE 2nd Gen (product_id=6, 7990000 VND). COMPLETED.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=106, user_id='cccccccc-0006-4000-a000-000000000006', phone='0911234506', address_line='34 Đường Lê Lợi', city='Huế', district_id=11, state_id=6, country_id=1, is_default=true |
| cart | cart_item | customer_id='cccccccc-0006-4000-a000-000000000006', product_id=6, quantity=1 |
| order | checkout | id=6, customer_id='cccccccc-0006-4000-a000-000000000006', email='order_thanh@test.com', shipping_address_id=106, billing_address_id=106, total_amount=7990000, payment_method='COD' |
| order | order | id=6, checkout_id=6, customer_id='cccccccc-0006-4000-a000-000000000006', total_amount=7990000, order_status='COMPLETED' |

Keycloak: `id=cccccccc-0006-4000-a000-000000000006, username=order_thanh, email=order_thanh@test.com, role=CUSTOMER`

---

### Scenario 7 — Nguyen Thi Bich orders 2 serums

Nguyen Thi Bich orders 2 L'Oréal HA Serums (product_id=7, 840000 VND). COMPLETED.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=107, user_id='cccccccc-0007-4000-a000-000000000007', phone='0911234507', address_line='90 Đường Trần Phú', city='Nha Trang', district_id=13, state_id=7, country_id=1, is_default=true |
| cart | cart_item | customer_id='cccccccc-0007-4000-a000-000000000007', product_id=7, quantity=2 |
| order | checkout | id=7, customer_id='cccccccc-0007-4000-a000-000000000007', email='order_bich@test.com', shipping_address_id=107, billing_address_id=107, total_amount=840000, payment_method='BANK_TRANSFER' |
| order | order | id=7, checkout_id=7, customer_id='cccccccc-0007-4000-a000-000000000007', total_amount=840000, order_status='COMPLETED' |

Keycloak: `id=cccccccc-0007-4000-a000-000000000007, username=order_bich, email=order_bich@test.com, role=CUSTOMER`

---

### Scenario 8 — Do Manh Cuong orders gaming headset

Do Manh Cuong orders Logitech G435 (product_id=8, 1590000 VND). COMPLETED.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=108, user_id='cccccccc-0008-4000-a000-000000000008', phone='0911234508', address_line='15 Đường Trần Hưng Đạo', city='Đà Lạt', district_id=15, state_id=8, country_id=1, is_default=true |
| cart | cart_item | customer_id='cccccccc-0008-4000-a000-000000000008', product_id=8, quantity=1 |
| order | checkout | id=8, customer_id='cccccccc-0008-4000-a000-000000000008', email='order_cuong@test.com', shipping_address_id=108, billing_address_id=108, total_amount=1590000, payment_method='COD' |
| order | order | id=8, checkout_id=8, customer_id='cccccccc-0008-4000-a000-000000000008', total_amount=1590000, order_status='COMPLETED' |

Keycloak: `id=cccccccc-0008-4000-a000-000000000008, username=order_cuong, email=order_cuong@test.com, role=CUSTOMER`

---

### Scenario 9 — Tran Thi Oanh orders matcha

Tran Thi Oanh orders 2 Uji Matcha 100g (product_id=9, 760000 VND). COMPLETED.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=109, user_id='cccccccc-0009-4000-a000-000000000009', phone='0911234509', address_line='67 Đường Thùy Vân', city='Vũng Tàu', district_id=17, state_id=9, country_id=1, is_default=true |
| cart | cart_item | customer_id='cccccccc-0009-4000-a000-000000000009', product_id=9, quantity=2 |
| order | checkout | id=9, customer_id='cccccccc-0009-4000-a000-000000000009', email='order_oanh@test.com', shipping_address_id=109, billing_address_id=109, total_amount=760000, payment_method='COD' |
| order | order | id=9, checkout_id=9, customer_id='cccccccc-0009-4000-a000-000000000009', total_amount=760000, order_status='COMPLETED' |

Keycloak: `id=cccccccc-0009-4000-a000-000000000009, username=order_oanh, email=order_oanh@test.com, role=CUSTOMER`

---

### Scenario 10 — Bui Van Duc orders yoga mat

Bui Van Duc orders Manduka PRO 6mm (product_id=10, 2750000 VND). COMPLETED.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=110, user_id='cccccccc-0010-4000-a000-000000000010', phone='0911234510', address_line='88 Đường Đồng Khởi', city='Biên Hòa', district_id=19, state_id=10, country_id=1, is_default=true |
| cart | cart_item | customer_id='cccccccc-0010-4000-a000-000000000010', product_id=10, quantity=1 |
| order | checkout | id=10, customer_id='cccccccc-0010-4000-a000-000000000010', email='order_duc@test.com', shipping_address_id=110, billing_address_id=110, total_amount=2750000, payment_method='COD' |
| order | order | id=10, checkout_id=10, customer_id='cccccccc-0010-4000-a000-000000000010', total_amount=2750000, order_status='COMPLETED' |

Keycloak: `id=cccccccc-0010-4000-a000-000000000010, username=order_duc, email=order_duc@test.com, role=CUSTOMER`

---

### Scenario 11 — Ly Thi Phuong orders linen shirt

Ly Thi Phuong orders Mango Linen Shirt S (product_id=11, 790000 VND). COMPLETED.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=111, user_id='cccccccc-0011-4000-a000-000000000011', phone='0911234511', address_line='5 Phố Chùa Láng', city='Hà Nội', district_id=2, state_id=1, country_id=1, is_default=true |
| cart | cart_item | customer_id='cccccccc-0011-4000-a000-000000000011', product_id=11, quantity=1 |
| order | checkout | id=11, customer_id='cccccccc-0011-4000-a000-000000000011', email='order_phuong@test.com', shipping_address_id=111, billing_address_id=111, total_amount=790000, payment_method='COD' |
| order | order | id=11, checkout_id=11, customer_id='cccccccc-0011-4000-a000-000000000011', total_amount=790000, order_status='COMPLETED' |

Keycloak: `id=cccccccc-0011-4000-a000-000000000011, username=order_phuong, email=order_phuong@test.com, role=CUSTOMER`

---

### Scenario 12 — Nguyen Van An orders vacuum

Nguyen Van An orders Dyson V12 (product_id=12, 12990000 VND). COMPLETED.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=112, user_id='cccccccc-0012-4000-a000-000000000012', phone='0911234512', address_line='101 Đường Võ Thị Sáu', city='TP. Hồ Chí Minh', district_id=4, state_id=2, country_id=1, is_default=true |
| cart | cart_item | customer_id='cccccccc-0012-4000-a000-000000000012', product_id=12, quantity=1 |
| order | checkout | id=12, customer_id='cccccccc-0012-4000-a000-000000000012', email='order_an@test.com', shipping_address_id=112, billing_address_id=112, total_amount=12990000, payment_method='BANK_TRANSFER' |
| order | order | id=12, checkout_id=12, customer_id='cccccccc-0012-4000-a000-000000000012', total_amount=12990000, order_status='COMPLETED' |

Keycloak: `id=cccccccc-0012-4000-a000-000000000012, username=order_an, email=order_an@test.com, role=CUSTOMER`

---

### Scenario 13 — Dang Thi Lien orders books

Dang Thi Lien orders 2 Doraemon Vol.1 (product_id=13, 136000 VND). COMPLETED.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=113, user_id='cccccccc-0013-4000-a000-000000000013', phone='0911234513', address_line='32 Đường Phạm Văn Đồng', city='Đà Nẵng', district_id=6, state_id=3, country_id=1, is_default=true |
| cart | cart_item | customer_id='cccccccc-0013-4000-a000-000000000013', product_id=13, quantity=2 |
| order | checkout | id=13, customer_id='cccccccc-0013-4000-a000-000000000013', email='order_lien@test.com', shipping_address_id=113, billing_address_id=113, total_amount=136000, payment_method='COD' |
| order | order | id=13, checkout_id=13, customer_id='cccccccc-0013-4000-a000-000000000013', total_amount=136000, order_status='COMPLETED' |

Keycloak: `id=cccccccc-0013-4000-a000-000000000013, username=order_lien, email=order_lien@test.com, role=CUSTOMER`

---

### Scenario 14 — Phan Thi Xuan orders desk lamp

Phan Thi Xuan orders Xiaomi LED 1S (product_id=14, 690000 VND). COMPLETED.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=114, user_id='cccccccc-0014-4000-a000-000000000014', phone='0911234514', address_line='44 Phố Lý Tự Trọng', city='Hải Phòng', district_id=8, state_id=4, country_id=1, is_default=true |
| cart | cart_item | customer_id='cccccccc-0014-4000-a000-000000000014', product_id=14, quantity=1 |
| order | checkout | id=14, customer_id='cccccccc-0014-4000-a000-000000000014', email='order_xuan@test.com', shipping_address_id=114, billing_address_id=114, total_amount=690000, payment_method='COD' |
| order | order | id=14, checkout_id=14, customer_id='cccccccc-0014-4000-a000-000000000014', total_amount=690000, order_status='COMPLETED' |

Keycloak: `id=cccccccc-0014-4000-a000-000000000014, username=order_xuan, email=order_xuan@test.com, role=CUSTOMER`

---

### Scenario 15 — Truong Van Long orders cutting board set

Truong Van Long orders JJ Folio 4-piece (product_id=15, 850000 VND). COMPLETED.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=115, user_id='cccccccc-0015-4000-a000-000000000015', phone='0911234515', address_line='19 Đường Nguyễn Văn Cừ', city='Cần Thơ', district_id=10, state_id=5, country_id=1, is_default=true |
| cart | cart_item | customer_id='cccccccc-0015-4000-a000-000000000015', product_id=15, quantity=1 |
| order | checkout | id=15, customer_id='cccccccc-0015-4000-a000-000000000015', email='order_long@test.com', shipping_address_id=115, billing_address_id=115, total_amount=850000, payment_method='COD' |
| order | order | id=15, checkout_id=15, customer_id='cccccccc-0015-4000-a000-000000000015', total_amount=850000, order_status='COMPLETED' |

Keycloak: `id=cccccccc-0015-4000-a000-000000000015, username=order_long, email=order_long@test.com, role=CUSTOMER`

---

### Scenario 16 — Cao Thi Nga orders vitamins

Cao Thi Nga orders 2 Now Vitamin C-1000 (product_id=16, 620000 VND). COMPLETED.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=116, user_id='cccccccc-0016-4000-a000-000000000016', phone='0911234516', address_line='7 Đường Hai Bà Trưng', city='Huế', district_id=12, state_id=6, country_id=1, is_default=true |
| cart | cart_item | customer_id='cccccccc-0016-4000-a000-000000000016', product_id=16, quantity=2 |
| order | checkout | id=16, customer_id='cccccccc-0016-4000-a000-000000000016', email='order_nga@test.com', shipping_address_id=116, billing_address_id=116, total_amount=620000, payment_method='COD' |
| order | order | id=16, checkout_id=16, customer_id='cccccccc-0016-4000-a000-000000000016', total_amount=620000, order_status='COMPLETED' |

Keycloak: `id=cccccccc-0016-4000-a000-000000000016, username=order_nga, email=order_nga@test.com, role=CUSTOMER`

---

### Scenario 17 — Mai Van Son orders keyboard

Mai Van Son orders Keychron K2 Pro Red (product_id=17, 2490000 VND). COMPLETED.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=117, user_id='cccccccc-0017-4000-a000-000000000017', phone='0911234517', address_line='25 Đường Nguyễn Thiện Thuật', city='Nha Trang', district_id=14, state_id=7, country_id=1, is_default=true |
| cart | cart_item | customer_id='cccccccc-0017-4000-a000-000000000017', product_id=17, quantity=1 |
| order | checkout | id=17, customer_id='cccccccc-0017-4000-a000-000000000017', email='order_son@test.com', shipping_address_id=117, billing_address_id=117, total_amount=2490000, payment_method='BANK_TRANSFER' |
| order | order | id=17, checkout_id=17, customer_id='cccccccc-0017-4000-a000-000000000017', total_amount=2490000, order_status='COMPLETED' |

Keycloak: `id=cccccccc-0017-4000-a000-000000000017, username=order_son, email=order_son@test.com, role=CUSTOMER`

---

### Scenario 18 — Vo Thi Kim orders silk scarf

Vo Thi Kim orders Khaisilk Floral Scarf (product_id=18, 1200000 VND). COMPLETED.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=118, user_id='cccccccc-0018-4000-a000-000000000018', phone='0911234518', address_line='38 Đường Phan Đình Phùng', city='Đà Lạt', district_id=16, state_id=8, country_id=1, is_default=true |
| cart | cart_item | customer_id='cccccccc-0018-4000-a000-000000000018', product_id=18, quantity=1 |
| order | checkout | id=18, customer_id='cccccccc-0018-4000-a000-000000000018', email='order_kim@test.com', shipping_address_id=118, billing_address_id=118, total_amount=1200000, payment_method='COD' |
| order | order | id=18, checkout_id=18, customer_id='cccccccc-0018-4000-a000-000000000018', total_amount=1200000, order_status='COMPLETED' |

Keycloak: `id=cccccccc-0018-4000-a000-000000000018, username=order_kim, email=order_kim@test.com, role=CUSTOMER`

---

### Scenario 19 — Nguyen Duc Tuan orders bluetooth speaker

Nguyen Duc Tuan orders JBL Flip 6 (product_id=19, 2990000 VND). COMPLETED.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=119, user_id='cccccccc-0019-4000-a000-000000000019', phone='0911234519', address_line='52 Đường Nam Kỳ Khởi Nghĩa', city='Vũng Tàu', district_id=18, state_id=9, country_id=1, is_default=true |
| cart | cart_item | customer_id='cccccccc-0019-4000-a000-000000000019', product_id=19, quantity=1 |
| order | checkout | id=19, customer_id='cccccccc-0019-4000-a000-000000000019', email='order_tuan@test.com', shipping_address_id=119, billing_address_id=119, total_amount=2990000, payment_method='COD' |
| order | order | id=19, checkout_id=19, customer_id='cccccccc-0019-4000-a000-000000000019', total_amount=2990000, order_status='COMPLETED' |

Keycloak: `id=cccccccc-0019-4000-a000-000000000019, username=order_tuan, email=order_tuan@test.com, role=CUSTOMER`

---

### Scenario 20 — Le Van Hai orders 3 succulents

Le Van Hai orders 3 Haworthia pots (product_id=20, 285000 VND). COMPLETED.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=120, user_id='cccccccc-0020-4000-a000-000000000020', phone='0911234520', address_line='77 Đường Cách Mạng Tháng 8', city='Biên Hòa', district_id=20, state_id=10, country_id=1, is_default=true |
| cart | cart_item | customer_id='cccccccc-0020-4000-a000-000000000020', product_id=20, quantity=3 |
| order | checkout | id=20, customer_id='cccccccc-0020-4000-a000-000000000020', email='order_hai@test.com', shipping_address_id=120, billing_address_id=120, total_amount=285000, payment_method='COD' |
| order | order | id=20, checkout_id=20, customer_id='cccccccc-0020-4000-a000-000000000020', total_amount=285000, order_status='COMPLETED' |

Keycloak: `id=cccccccc-0020-4000-a000-000000000020, username=order_hai, email=order_hai@test.com, role=CUSTOMER`

---

### Scenario 21 — Dinh Thi Huyen orders rice cooker

Dinh Thi Huyen orders Cuckoo CRP-P0609S (product_id=21, 5490000 VND). COMPLETED.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=121, user_id='cccccccc-0021-4000-a000-000000000021', phone='0911234521', address_line='3 Đinh Tiên Hoàng', city='Hà Nội', district_id=1, state_id=1, country_id=1, is_default=true |
| cart | cart_item | customer_id='cccccccc-0021-4000-a000-000000000021', product_id=21, quantity=1 |
| order | checkout | id=21, customer_id='cccccccc-0021-4000-a000-000000000021', email='order_huyen@test.com', shipping_address_id=121, billing_address_id=121, total_amount=5490000, payment_method='BANK_TRANSFER' |
| order | order | id=21, checkout_id=21, customer_id='cccccccc-0021-4000-a000-000000000021', total_amount=5490000, order_status='COMPLETED' |

Keycloak: `id=cccccccc-0021-4000-a000-000000000021, username=order_huyen, email=order_huyen@test.com, role=CUSTOMER`

---

### Scenario 22 — Ngo Van Cuong orders fishing combo

Ngo Van Cuong orders Shimano Sienna FE 2500 (product_id=22, 890000 VND). COMPLETED.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=122, user_id='cccccccc-0022-4000-a000-000000000022', phone='0911234522', address_line='200 Đường Lý Chính Thắng', city='TP. Hồ Chí Minh', district_id=3, state_id=2, country_id=1, is_default=true |
| cart | cart_item | customer_id='cccccccc-0022-4000-a000-000000000022', product_id=22, quantity=1 |
| order | checkout | id=22, customer_id='cccccccc-0022-4000-a000-000000000022', email='order_cuong2@test.com', shipping_address_id=122, billing_address_id=122, total_amount=890000, payment_method='COD' |
| order | order | id=22, checkout_id=22, customer_id='cccccccc-0022-4000-a000-000000000022', total_amount=890000, order_status='COMPLETED' |

Keycloak: `id=cccccccc-0022-4000-a000-000000000022, username=order_cuong2, email=order_cuong2@test.com, role=CUSTOMER`

---

### Scenario 23 — Pham Thi Mai orders toner

Pham Thi Mai orders 2 COSRX AHA/BHA Toners (product_id=23, 570000 VND). COMPLETED.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=123, user_id='cccccccc-0023-4000-a000-000000000023', phone='0911234523', address_line='16 Đường Trần Phú', city='Đà Nẵng', district_id=5, state_id=3, country_id=1, is_default=true |
| cart | cart_item | customer_id='cccccccc-0023-4000-a000-000000000023', product_id=23, quantity=2 |
| order | checkout | id=23, customer_id='cccccccc-0023-4000-a000-000000000023', email='order_mai@test.com', shipping_address_id=123, billing_address_id=123, total_amount=570000, payment_method='COD' |
| order | order | id=23, checkout_id=23, customer_id='cccccccc-0023-4000-a000-000000000023', total_amount=570000, order_status='COMPLETED' |

Keycloak: `id=cccccccc-0023-4000-a000-000000000023, username=order_mai, email=order_mai@test.com, role=CUSTOMER`

---

### Scenario 24 — Tran Duc Khanh orders watch cable

Tran Duc Khanh orders Garmin FR255 charger (product_id=24, 290000 VND). COMPLETED.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=124, user_id='cccccccc-0024-4000-a000-000000000024', phone='0911234524', address_line='60 Đường Tô Hiệu', city='Hải Phòng', district_id=7, state_id=4, country_id=1, is_default=true |
| cart | cart_item | customer_id='cccccccc-0024-4000-a000-000000000024', product_id=24, quantity=1 |
| order | checkout | id=24, customer_id='cccccccc-0024-4000-a000-000000000024', email='order_khanh@test.com', shipping_address_id=124, billing_address_id=124, total_amount=290000, payment_method='COD' |
| order | order | id=24, checkout_id=24, customer_id='cccccccc-0024-4000-a000-000000000024', total_amount=290000, order_status='COMPLETED' |

Keycloak: `id=cccccccc-0024-4000-a000-000000000024, username=order_khanh, email=order_khanh@test.com, role=CUSTOMER`

---

### Scenario 25 — Bui Thi Lan orders frying pan

Bui Thi Lan orders Tefal ECC 28cm (product_id=25, 690000 VND). COMPLETED.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=125, user_id='cccccccc-0025-4000-a000-000000000025', phone='0911234525', address_line='9 Đường Hoà Bình', city='Cần Thơ', district_id=9, state_id=5, country_id=1, is_default=true |
| cart | cart_item | customer_id='cccccccc-0025-4000-a000-000000000025', product_id=25, quantity=1 |
| order | checkout | id=25, customer_id='cccccccc-0025-4000-a000-000000000025', email='order_lan2@test.com', shipping_address_id=125, billing_address_id=125, total_amount=690000, payment_method='COD' |
| order | order | id=25, checkout_id=25, customer_id='cccccccc-0025-4000-a000-000000000025', total_amount=690000, order_status='COMPLETED' |

Keycloak: `id=cccccccc-0025-4000-a000-000000000025, username=order_lan2, email=order_lan2@test.com, role=CUSTOMER`

---

### Scenario 26 — Hoang Van Binh orders polo shirt

Hoang Van Binh orders Lacoste Classic Polo Navy M (product_id=26, 1850000 VND). COMPLETED.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=126, user_id='cccccccc-0026-4000-a000-000000000026', phone='0911234526', address_line='41 Đường Nguyễn Trãi', city='Huế', district_id=11, state_id=6, country_id=1, is_default=true |
| cart | cart_item | customer_id='cccccccc-0026-4000-a000-000000000026', product_id=26, quantity=1 |
| order | checkout | id=26, customer_id='cccccccc-0026-4000-a000-000000000026', email='order_binh@test.com', shipping_address_id=126, billing_address_id=126, total_amount=1850000, payment_method='BANK_TRANSFER' |
| order | order | id=26, checkout_id=26, customer_id='cccccccc-0026-4000-a000-000000000026', total_amount=1850000, order_status='COMPLETED' |

Keycloak: `id=cccccccc-0026-4000-a000-000000000026, username=order_binh, email=order_binh@test.com, role=CUSTOMER`

---

### Scenario 27 — Nguyen Thi Thanh Thuy orders kids bike

Nguyen Thi Thanh Thuy orders Giant ARX 20 Blue (product_id=27, 4290000 VND). COMPLETED.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=127, user_id='cccccccc-0027-4000-a000-000000000027', phone='0911234527', address_line='73 Đường Nguyễn Đình Chiểu', city='Nha Trang', district_id=13, state_id=7, country_id=1, is_default=true |
| cart | cart_item | customer_id='cccccccc-0027-4000-a000-000000000027', product_id=27, quantity=1 |
| order | checkout | id=27, customer_id='cccccccc-0027-4000-a000-000000000027', email='order_thuy@test.com', shipping_address_id=127, billing_address_id=127, total_amount=4290000, payment_method='BANK_TRANSFER' |
| order | order | id=27, checkout_id=27, customer_id='cccccccc-0027-4000-a000-000000000027', total_amount=4290000, order_status='COMPLETED' |

Keycloak: `id=cccccccc-0027-4000-a000-000000000027, username=order_thuy, email=order_thuy@test.com, role=CUSTOMER`

---

### Scenario 28 — Le Hoang Nam orders power bank

Le Hoang Nam orders Anker PowerCore 20000mAh (product_id=28, 1090000 VND). COMPLETED.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=128, user_id='cccccccc-0028-4000-a000-000000000028', phone='0911234528', address_line='22 Đường Đinh Tiên Hoàng', city='Đà Lạt', district_id=15, state_id=8, country_id=1, is_default=true |
| cart | cart_item | customer_id='cccccccc-0028-4000-a000-000000000028', product_id=28, quantity=1 |
| order | checkout | id=28, customer_id='cccccccc-0028-4000-a000-000000000028', email='order_nam@test.com', shipping_address_id=128, billing_address_id=128, total_amount=1090000, payment_method='COD' |
| order | order | id=28, checkout_id=28, customer_id='cccccccc-0028-4000-a000-000000000028', total_amount=1090000, order_status='COMPLETED' |

Keycloak: `id=cccccccc-0028-4000-a000-000000000028, username=order_nam, email=order_nam@test.com, role=CUSTOMER`

---

### Scenario 29 — Tran Thi Quynh orders puzzle

Tran Thi Quynh orders Ravensburger Hoi An 1000p (product_id=29, 395000 VND). COMPLETED.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=129, user_id='cccccccc-0029-4000-a000-000000000029', phone='0911234529', address_line='85 Đường Lý Thường Kiệt', city='Vũng Tàu', district_id=17, state_id=9, country_id=1, is_default=true |
| cart | cart_item | customer_id='cccccccc-0029-4000-a000-000000000029', product_id=29, quantity=1 |
| order | checkout | id=29, customer_id='cccccccc-0029-4000-a000-000000000029', email='order_quynh@test.com', shipping_address_id=129, billing_address_id=129, total_amount=395000, payment_method='COD' |
| order | order | id=29, checkout_id=29, customer_id='cccccccc-0029-4000-a000-000000000029', total_amount=395000, order_status='COMPLETED' |

Keycloak: `id=cccccccc-0029-4000-a000-000000000029, username=order_quynh, email=order_quynh@test.com, role=CUSTOMER`

---

### Scenario 30 — Vu Thi Thu Hang orders perfume

Vu Thi Thu Hang orders Chanel Chance Tendre 50ml (product_id=30, 4500000 VND). COMPLETED.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=130, user_id='cccccccc-0030-4000-a000-000000000030', phone='0911234530', address_line='14 Đường Phạm Văn Thuận', city='Biên Hòa', district_id=19, state_id=10, country_id=1, is_default=true |
| cart | cart_item | customer_id='cccccccc-0030-4000-a000-000000000030', product_id=30, quantity=1 |
| order | checkout | id=30, customer_id='cccccccc-0030-4000-a000-000000000030', email='order_hang@test.com', shipping_address_id=130, billing_address_id=130, total_amount=4500000, payment_method='BANK_TRANSFER' |
| order | order | id=30, checkout_id=30, customer_id='cccccccc-0030-4000-a000-000000000030', total_amount=4500000, order_status='COMPLETED' |

Keycloak: `id=cccccccc-0030-4000-a000-000000000030, username=order_hang, email=order_hang@test.com, role=CUSTOMER`

---

### Scenario 31 — Nguyen Van Hieu orders router

Nguyen Van Hieu orders TP-Link Archer AX73 (product_id=31, 3490000 VND). COMPLETED.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=131, user_id='cccccccc-0031-4000-a000-000000000031', phone='0911234531', address_line='91 Phố Khâm Thiên', city='Hà Nội', district_id=2, state_id=1, country_id=1, is_default=true |
| cart | cart_item | customer_id='cccccccc-0031-4000-a000-000000000031', product_id=31, quantity=1 |
| order | checkout | id=31, customer_id='cccccccc-0031-4000-a000-000000000031', email='order_hieu@test.com', shipping_address_id=131, billing_address_id=131, total_amount=3490000, payment_method='BANK_TRANSFER' |
| order | order | id=31, checkout_id=31, customer_id='cccccccc-0031-4000-a000-000000000031', total_amount=3490000, order_status='COMPLETED' |

Keycloak: `id=cccccccc-0031-4000-a000-000000000031, username=order_hieu, email=order_hieu@test.com, role=CUSTOMER`

---

### Scenario 32 — Trinh Thi Nga orders 3 essential oils

Trinh Thi Nga orders 3 Plant Therapy Lavender 30ml (product_id=32, 840000 VND). COMPLETED.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=132, user_id='cccccccc-0032-4000-a000-000000000032', phone='0911234532', address_line='37 Đường Nam Kỳ Khởi Nghĩa', city='TP. Hồ Chí Minh', district_id=4, state_id=2, country_id=1, is_default=true |
| cart | cart_item | customer_id='cccccccc-0032-4000-a000-000000000032', product_id=32, quantity=3 |
| order | checkout | id=32, customer_id='cccccccc-0032-4000-a000-000000000032', email='order_nga2@test.com', shipping_address_id=132, billing_address_id=132, total_amount=840000, payment_method='COD' |
| order | order | id=32, checkout_id=32, customer_id='cccccccc-0032-4000-a000-000000000032', total_amount=840000, order_status='COMPLETED' |

Keycloak: `id=cccccccc-0032-4000-a000-000000000032, username=order_nga2, email=order_nga2@test.com, role=CUSTOMER`

---

### Scenario 33 — Pham Van Tung orders whey protein

Pham Van Tung orders ON Gold Standard 2lb (product_id=33, 1190000 VND). COMPLETED.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=133, user_id='cccccccc-0033-4000-a000-000000000033', phone='0911234533', address_line='55 Đường Võ Nguyên Giáp', city='Đà Nẵng', district_id=6, state_id=3, country_id=1, is_default=true |
| cart | cart_item | customer_id='cccccccc-0033-4000-a000-000000000033', product_id=33, quantity=1 |
| order | checkout | id=33, customer_id='cccccccc-0033-4000-a000-000000000033', email='order_tung@test.com', shipping_address_id=133, billing_address_id=133, total_amount=1190000, payment_method='COD' |
| order | order | id=33, checkout_id=33, customer_id='cccccccc-0033-4000-a000-000000000033', total_amount=1190000, order_status='COMPLETED' |

Keycloak: `id=cccccccc-0033-4000-a000-000000000033, username=order_tung, email=order_tung@test.com, role=CUSTOMER`

---

### Scenario 34 — Hoang Thi Bao Ngoc orders planner

Hoang Thi Bao Ngoc orders Hobonichi A6 2025 (product_id=34, 890000 VND). COMPLETED.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=134, user_id='cccccccc-0034-4000-a000-000000000034', phone='0911234534', address_line='18 Phố Quang Trung', city='Hải Phòng', district_id=8, state_id=4, country_id=1, is_default=true |
| cart | cart_item | customer_id='cccccccc-0034-4000-a000-000000000034', product_id=34, quantity=1 |
| order | checkout | id=34, customer_id='cccccccc-0034-4000-a000-000000000034', email='order_ngoc@test.com', shipping_address_id=134, billing_address_id=134, total_amount=890000, payment_method='COD' |
| order | order | id=34, checkout_id=34, customer_id='cccccccc-0034-4000-a000-000000000034', total_amount=890000, order_status='COMPLETED' |

Keycloak: `id=cccccccc-0034-4000-a000-000000000034, username=order_ngoc, email=order_ngoc@test.com, role=CUSTOMER`

---

### Scenario 35 — Nguyen Thi Diem orders 4 sunscreens

Nguyen Thi Diem orders 4 Anessa SPF50+ (product_id=35, 2480000 VND). COMPLETED.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=135, user_id='cccccccc-0035-4000-a000-000000000035', phone='0911234535', address_line='63 Đường Mậu Thân', city='Cần Thơ', district_id=10, state_id=5, country_id=1, is_default=true |
| cart | cart_item | customer_id='cccccccc-0035-4000-a000-000000000035', product_id=35, quantity=4 |
| order | checkout | id=35, customer_id='cccccccc-0035-4000-a000-000000000035', email='order_diem@test.com', shipping_address_id=135, billing_address_id=135, total_amount=2480000, payment_method='COD' |
| order | order | id=35, checkout_id=35, customer_id='cccccccc-0035-4000-a000-000000000035', total_amount=2480000, order_status='COMPLETED' |

Keycloak: `id=cccccccc-0035-4000-a000-000000000035, username=order_diem, email=order_diem@test.com, role=CUSTOMER`

---

### Scenario 36 — Dao Van Kien orders phone case

Dao Van Kien orders Spigen Ultra Hybrid iPhone 15 Pro (product_id=36, 395000 VND). COMPLETED.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=136, user_id='cccccccc-0036-4000-a000-000000000036', phone='0911234536', address_line='28 Đường Trần Cao Vân', city='Huế', district_id=12, state_id=6, country_id=1, is_default=true |
| cart | cart_item | customer_id='cccccccc-0036-4000-a000-000000000036', product_id=36, quantity=1 |
| order | checkout | id=36, customer_id='cccccccc-0036-4000-a000-000000000036', email='order_kien@test.com', shipping_address_id=136, billing_address_id=136, total_amount=395000, payment_method='COD' |
| order | order | id=36, checkout_id=36, customer_id='cccccccc-0036-4000-a000-000000000036', total_amount=395000, order_status='COMPLETED' |

Keycloak: `id=cccccccc-0036-4000-a000-000000000036, username=order_kien, email=order_kien@test.com, role=CUSTOMER`

---

### Scenario 37 — Luong Thi Thao orders hair dryer

Luong Thi Thao orders Dyson Supersonic (product_id=37, 16500000 VND). COMPLETED.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=137, user_id='cccccccc-0037-4000-a000-000000000037', phone='0911234537', address_line='47 Đường Ngô Gia Tự', city='Nha Trang', district_id=14, state_id=7, country_id=1, is_default=true |
| cart | cart_item | customer_id='cccccccc-0037-4000-a000-000000000037', product_id=37, quantity=1 |
| order | checkout | id=37, customer_id='cccccccc-0037-4000-a000-000000000037', email='order_thao@test.com', shipping_address_id=137, billing_address_id=137, total_amount=16500000, payment_method='BANK_TRANSFER' |
| order | order | id=37, checkout_id=37, customer_id='cccccccc-0037-4000-a000-000000000037', total_amount=16500000, order_status='COMPLETED' |

Keycloak: `id=cccccccc-0037-4000-a000-000000000037, username=order_thao, email=order_thao@test.com, role=CUSTOMER`

---

### Scenario 38 — Do Van Thanh orders travel pillow

Do Van Thanh orders Trtl Plus Navy (product_id=38, 790000 VND). COMPLETED.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=138, user_id='cccccccc-0038-4000-a000-000000000038', phone='0911234538', address_line='11 Đường Lý Tự Trọng', city='Đà Lạt', district_id=16, state_id=8, country_id=1, is_default=true |
| cart | cart_item | customer_id='cccccccc-0038-4000-a000-000000000038', product_id=38, quantity=1 |
| order | checkout | id=38, customer_id='cccccccc-0038-4000-a000-000000000038', email='order_thanh2@test.com', shipping_address_id=138, billing_address_id=138, total_amount=790000, payment_method='COD' |
| order | order | id=38, checkout_id=38, customer_id='cccccccc-0038-4000-a000-000000000038', total_amount=790000, order_status='COMPLETED' |

Keycloak: `id=cccccccc-0038-4000-a000-000000000038, username=order_thanh2, email=order_thanh2@test.com, role=CUSTOMER`

---

### Scenario 39 — Nguyen Thi Hong orders waffle maker

Nguyen Thi Hong orders Cuisinart WMB-4 (product_id=39, 1490000 VND). COMPLETED.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=139, user_id='cccccccc-0039-4000-a000-000000000039', phone='0911234539', address_line='99 Đường Lê Hồng Phong', city='Vũng Tàu', district_id=18, state_id=9, country_id=1, is_default=true |
| cart | cart_item | customer_id='cccccccc-0039-4000-a000-000000000039', product_id=39, quantity=1 |
| order | checkout | id=39, customer_id='cccccccc-0039-4000-a000-000000000039', email='order_hong@test.com', shipping_address_id=139, billing_address_id=139, total_amount=1490000, payment_method='COD' |
| order | order | id=39, checkout_id=39, customer_id='cccccccc-0039-4000-a000-000000000039', total_amount=1490000, order_status='COMPLETED' |

Keycloak: `id=cccccccc-0039-4000-a000-000000000039, username=order_hong, email=order_hong@test.com, role=CUSTOMER`

---

### Scenario 40 — Tran Quoc Bao orders drawing tablet

Tran Quoc Bao orders Wacom Intuos Small Wireless (product_id=40, 2190000 VND). COMPLETED.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=140, user_id='cccccccc-0040-4000-a000-000000000040', phone='0911234540', address_line='50 Đường Lê Duẩn', city='Biên Hòa', district_id=20, state_id=10, country_id=1, is_default=true |
| cart | cart_item | customer_id='cccccccc-0040-4000-a000-000000000040', product_id=40, quantity=1 |
| order | checkout | id=40, customer_id='cccccccc-0040-4000-a000-000000000040', email='order_bao@test.com', shipping_address_id=140, billing_address_id=140, total_amount=2190000, payment_method='BANK_TRANSFER' |
| order | order | id=40, checkout_id=40, customer_id='cccccccc-0040-4000-a000-000000000040', total_amount=2190000, order_status='COMPLETED' |

Keycloak: `id=cccccccc-0040-4000-a000-000000000040, username=order_bao, email=order_bao@test.com, role=CUSTOMER`

---

### Scenario 41 — Ly Thi Cam orders 3 baby formula

Ly Thi Cam orders 3 Enfamil NeuroPro 865g (product_id=41, 2340000 VND). COMPLETED.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=141, user_id='cccccccc-0041-4000-a000-000000000041', phone='0911234541', address_line='6 Phố Hàng Đào', city='Hà Nội', district_id=1, state_id=1, country_id=1, is_default=true |
| cart | cart_item | customer_id='cccccccc-0041-4000-a000-000000000041', product_id=41, quantity=3 |
| order | checkout | id=41, customer_id='cccccccc-0041-4000-a000-000000000041', email='order_cam@test.com', shipping_address_id=141, billing_address_id=141, total_amount=2340000, payment_method='COD' |
| order | order | id=41, checkout_id=41, customer_id='cccccccc-0041-4000-a000-000000000041', total_amount=2340000, order_status='COMPLETED' |

Keycloak: `id=cccccccc-0041-4000-a000-000000000041, username=order_cam, email=order_cam@test.com, role=CUSTOMER`

---

### Scenario 42 — Nguyen Van Khanh orders dartboard

Nguyen Van Khanh orders Winmau Blade 6 (product_id=42, 1350000 VND). COMPLETED.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=142, user_id='cccccccc-0042-4000-a000-000000000042', phone='0911234542', address_line='300 Đường Đinh Tiên Hoàng', city='TP. Hồ Chí Minh', district_id=3, state_id=2, country_id=1, is_default=true |
| cart | cart_item | customer_id='cccccccc-0042-4000-a000-000000000042', product_id=42, quantity=1 |
| order | checkout | id=42, customer_id='cccccccc-0042-4000-a000-000000000042', email='order_khanh2@test.com', shipping_address_id=142, billing_address_id=142, total_amount=1350000, payment_method='COD' |
| order | order | id=42, checkout_id=42, customer_id='cccccccc-0042-4000-a000-000000000042', total_amount=1350000, order_status='COMPLETED' |

Keycloak: `id=cccccccc-0042-4000-a000-000000000042, username=order_khanh2, email=order_khanh2@test.com, role=CUSTOMER`

---

### Scenario 43 — Phan Thi My Hanh orders 5 food containers

Phan Thi My Hanh orders 5 Sistema Brilliance 1.6L (product_id=43, 925000 VND). COMPLETED.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=143, user_id='cccccccc-0043-4000-a000-000000000043', phone='0911234543', address_line='48 Đường Hùng Vương', city='Đà Nẵng', district_id=5, state_id=3, country_id=1, is_default=true |
| cart | cart_item | customer_id='cccccccc-0043-4000-a000-000000000043', product_id=43, quantity=5 |
| order | checkout | id=43, customer_id='cccccccc-0043-4000-a000-000000000043', email='order_hanh@test.com', shipping_address_id=143, billing_address_id=143, total_amount=925000, payment_method='COD' |
| order | order | id=43, checkout_id=43, customer_id='cccccccc-0043-4000-a000-000000000043', total_amount=925000, order_status='COMPLETED' |

Keycloak: `id=cccccccc-0043-4000-a000-000000000043, username=order_hanh, email=order_hanh@test.com, role=CUSTOMER`

---

### Scenario 44 — Cao Minh Duc orders earbuds

Cao Minh Duc orders Sony WF-1000XM5 (product_id=44, 6490000 VND). COMPLETED.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=144, user_id='cccccccc-0044-4000-a000-000000000044', phone='0911234544', address_line='82 Đường Lê Thánh Tông', city='Hải Phòng', district_id=7, state_id=4, country_id=1, is_default=true |
| cart | cart_item | customer_id='cccccccc-0044-4000-a000-000000000044', product_id=44, quantity=1 |
| order | checkout | id=44, customer_id='cccccccc-0044-4000-a000-000000000044', email='order_duc2@test.com', shipping_address_id=144, billing_address_id=144, total_amount=6490000, payment_method='BANK_TRANSFER' |
| order | order | id=44, checkout_id=44, customer_id='cccccccc-0044-4000-a000-000000000044', total_amount=6490000, order_status='COMPLETED' |

Keycloak: `id=cccccccc-0044-4000-a000-000000000044, username=order_duc2, email=order_duc2@test.com, role=CUSTOMER`

---

### Scenario 45 — Nguyen Thi Nhu Quynh orders water bottle

Nguyen Thi Nhu Quynh orders Hydro Flask 32oz Flamingo (product_id=45, 1190000 VND). COMPLETED.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=145, user_id='cccccccc-0045-4000-a000-000000000045', phone='0911234545', address_line='31 Đường Cần Thơ', city='Cần Thơ', district_id=9, state_id=5, country_id=1, is_default=true |
| cart | cart_item | customer_id='cccccccc-0045-4000-a000-000000000045', product_id=45, quantity=1 |
| order | checkout | id=45, customer_id='cccccccc-0045-4000-a000-000000000045', email='order_quynh2@test.com', shipping_address_id=145, billing_address_id=145, total_amount=1190000, payment_method='COD' |
| order | order | id=45, checkout_id=45, customer_id='cccccccc-0045-4000-a000-000000000045', total_amount=1190000, order_status='COMPLETED' |

Keycloak: `id=cccccccc-0045-4000-a000-000000000045, username=order_quynh2, email=order_quynh2@test.com, role=CUSTOMER`

---

### Scenario 46 — Vo Ngoc Tuan orders projector

Vo Ngoc Tuan orders Anker Nebula Capsule II (product_id=46, 9990000 VND). COMPLETED.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=146, user_id='cccccccc-0046-4000-a000-000000000046', phone='0911234546', address_line='58 Đường Phan Bội Châu', city='Huế', district_id=11, state_id=6, country_id=1, is_default=true |
| cart | cart_item | customer_id='cccccccc-0046-4000-a000-000000000046', product_id=46, quantity=1 |
| order | checkout | id=46, customer_id='cccccccc-0046-4000-a000-000000000046', email='order_tuan2@test.com', shipping_address_id=146, billing_address_id=146, total_amount=9990000, payment_method='BANK_TRANSFER' |
| order | order | id=46, checkout_id=46, customer_id='cccccccc-0046-4000-a000-000000000046', total_amount=9990000, order_status='COMPLETED' |

Keycloak: `id=cccccccc-0046-4000-a000-000000000046, username=order_tuan2, email=order_tuan2@test.com, role=CUSTOMER`

---

### Scenario 47 — Bui Thi Thu Huong orders toothbrush

Bui Thi Thu Huong orders Oral-B iO Series 7 (product_id=47, 3990000 VND). COMPLETED.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=147, user_id='cccccccc-0047-4000-a000-000000000047', phone='0911234547', address_line='4 Đường Bến Chợ', city='Nha Trang', district_id=13, state_id=7, country_id=1, is_default=true |
| cart | cart_item | customer_id='cccccccc-0047-4000-a000-000000000047', product_id=47, quantity=1 |
| order | checkout | id=47, customer_id='cccccccc-0047-4000-a000-000000000047', email='order_huong@test.com', shipping_address_id=147, billing_address_id=147, total_amount=3990000, payment_method='BANK_TRANSFER' |
| order | order | id=47, checkout_id=47, customer_id='cccccccc-0047-4000-a000-000000000047', total_amount=3990000, order_status='COMPLETED' |

Keycloak: `id=cccccccc-0047-4000-a000-000000000047, username=order_huong, email=order_huong@test.com, role=CUSTOMER`

---

### Scenario 48 — Le Thi Xuan Mai orders 2 cookbooks

Le Thi Xuan Mai orders 2 Bếp Việt Miền Trung (product_id=48, 420000 VND). COMPLETED.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=148, user_id='cccccccc-0048-4000-a000-000000000048', phone='0911234548', address_line='66 Đường Trần Quốc Toản', city='Đà Lạt', district_id=16, state_id=8, country_id=1, is_default=true |
| cart | cart_item | customer_id='cccccccc-0048-4000-a000-000000000048', product_id=48, quantity=2 |
| order | checkout | id=48, customer_id='cccccccc-0048-4000-a000-000000000048', email='order_xmai@test.com', shipping_address_id=148, billing_address_id=148, total_amount=420000, payment_method='COD' |
| order | order | id=48, checkout_id=48, customer_id='cccccccc-0048-4000-a000-000000000048', total_amount=420000, order_status='COMPLETED' |

Keycloak: `id=cccccccc-0048-4000-a000-000000000048, username=order_xmai, email=order_xmai@test.com, role=CUSTOMER`

---

### Scenario 49 — Nguyen Thanh Phong orders car mount

Nguyen Thanh Phong orders Spigen GTS300 MagSafe (product_id=49, 590000 VND). COMPLETED.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=149, user_id='cccccccc-0049-4000-a000-000000000049', phone='0911234549', address_line='102 Đường Hoàng Hoa Thám', city='Vũng Tàu', district_id=17, state_id=9, country_id=1, is_default=true |
| cart | cart_item | customer_id='cccccccc-0049-4000-a000-000000000049', product_id=49, quantity=1 |
| order | checkout | id=49, customer_id='cccccccc-0049-4000-a000-000000000049', email='order_phong@test.com', shipping_address_id=149, billing_address_id=149, total_amount=590000, payment_method='COD' |
| order | order | id=49, checkout_id=49, customer_id='cccccccc-0049-4000-a000-000000000049', total_amount=590000, order_status='COMPLETED' |

Keycloak: `id=cccccccc-0049-4000-a000-000000000049, username=order_phong, email=order_phong@test.com, role=CUSTOMER`

---

### Scenario 50 — Tran Thi My Linh orders scented candle

Tran Thi My Linh orders Diptyque Baies 190g (product_id=50, 1850000 VND). COMPLETED.

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=150, user_id='cccccccc-0050-4000-a000-000000000050', phone='0911234550', address_line='39 Đường Phạm Văn Thuận', city='Biên Hòa', district_id=20, state_id=10, country_id=1, is_default=true |
| cart | cart_item | customer_id='cccccccc-0050-4000-a000-000000000050', product_id=50, quantity=1 |
| order | checkout | id=50, customer_id='cccccccc-0050-4000-a000-000000000050', email='order_linh@test.com', shipping_address_id=150, billing_address_id=150, total_amount=1850000, payment_method='COD' |
| order | order | id=50, checkout_id=50, customer_id='cccccccc-0050-4000-a000-000000000050', total_amount=1850000, order_status='COMPLETED' |

Keycloak: `id=cccccccc-0050-4000-a000-000000000050, username=order_linh, email=order_linh@test.com, role=CUSTOMER`

---

## Data State: customer_with_rating

*Enables flows: rating_create_rating_customer_success, rating_get_product_ratings_public_success, rating_get_avg_star_public_success, rating_list_admin_success, rating_delete_admin_success*

*Depends on: product_catalog group (products 1–50), location seed (country 1, provinces 1–10, districts 1–20)*

*UUID pattern: `dddddddd-00NN-4000-a000-000000000NNN` (N=01..50)*
*user_address ids: 201..250; checkout ids: 51..100; order ids: 51..100; rating ids: 1..50*

---

### Scenario 1 — Nguyen Thi Lan rates silk ao dai ★★★★★

Lan bought and received the silk ao dai (product_id=1). She gives 5 stars, headline "Đẹp lắm!", comment "Chất lụa mềm mại, màu sắc đẹp y hình".

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=201, user_id='dddddddd-0001-4000-a000-000000000001', phone='0921234501', address_line='12 Lý Thường Kiệt', city='Hà Nội', district_id=1, state_id=1, country_id=1, is_default=true |
| cart | cart_item | customer_id='dddddddd-0001-4000-a000-000000000001', product_id=1, quantity=1 |
| order | checkout | id=51, customer_id='dddddddd-0001-4000-a000-000000000001', email='rate_lan@test.com', shipping_address_id=201, billing_address_id=201, total_amount=850000, payment_method='COD' |
| order | order | id=51, checkout_id=51, customer_id='dddddddd-0001-4000-a000-000000000001', total_amount=850000, order_status='COMPLETED' |
| rating | rating | id=1, customer_id='dddddddd-0001-4000-a000-000000000001', product_id=1, rating_stars=5, headline='Đẹp lắm!', comment='Chất lụa mềm mại, màu sắc đẹp y hình', created_by='dddddddd-0001-4000-a000-000000000001', order_id=51 |

Keycloak: `id=dddddddd-0001-4000-a000-000000000001, username=rate_lan, email=rate_lan@test.com, role=CUSTOMER`

---

### Scenario 2 — Tran Van Minh rates Adidas shoes ★★★★

Minh bought Adidas Ultraboost (product_id=2). 4 stars. Headline "Êm chân", comment "Đế giày bền nhưng buộc dây hơi khó".

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=202, user_id='dddddddd-0002-4000-a000-000000000002', phone='0921234502', address_line='45 Nguyễn Huệ', city='TP. Hồ Chí Minh', district_id=3, state_id=2, country_id=1, is_default=true |
| cart | cart_item | customer_id='dddddddd-0002-4000-a000-000000000002', product_id=2, quantity=1 |
| order | checkout | id=52, customer_id='dddddddd-0002-4000-a000-000000000002', email='rate_minh@test.com', shipping_address_id=202, billing_address_id=202, total_amount=3200000, payment_method='COD' |
| order | order | id=52, checkout_id=52, customer_id='dddddddd-0002-4000-a000-000000000002', total_amount=3200000, order_status='COMPLETED' |
| rating | rating | id=2, customer_id='dddddddd-0002-4000-a000-000000000002', product_id=2, rating_stars=4, headline='Êm chân', comment='Đế giày bền nhưng buộc dây hơi khó', created_by='dddddddd-0002-4000-a000-000000000002', order_id=52 |

Keycloak: `id=dddddddd-0002-4000-a000-000000000002, username=rate_minh, email=rate_minh@test.com, role=CUSTOMER`

---

### Scenario 3 — Le Thi Hoa rates ceramic tea set ★★★★★

Hoa bought 2 tea sets (product_id=3). 5 stars. "Gốm thủ công tinh xảo, giao hàng cẩn thận".

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=203, user_id='dddddddd-0003-4000-a000-000000000003', phone='0921234503', address_line='78 Bạch Đằng', city='Đà Nẵng', district_id=5, state_id=3, country_id=1, is_default=true |
| cart | cart_item | customer_id='dddddddd-0003-4000-a000-000000000003', product_id=3, quantity=2 |
| order | checkout | id=53, customer_id='dddddddd-0003-4000-a000-000000000003', email='rate_hoa@test.com', shipping_address_id=203, billing_address_id=203, total_amount=1040000, payment_method='COD' |
| order | order | id=53, checkout_id=53, customer_id='dddddddd-0003-4000-a000-000000000003', total_amount=1040000, order_status='COMPLETED' |
| rating | rating | id=3, customer_id='dddddddd-0003-4000-a000-000000000003', product_id=3, rating_stars=5, headline='Gốm đẹp', comment='Gốm thủ công tinh xảo, giao hàng cẩn thận', created_by='dddddddd-0003-4000-a000-000000000003', order_id=53 |

Keycloak: `id=dddddddd-0003-4000-a000-000000000003, username=rate_hoa, email=rate_hoa@test.com, role=CUSTOMER`

---

### Scenario 4 — Pham Duc Hung rates Samsonite backpack ★★★★

Hung bought Guardit 2.0 (product_id=4). 4 stars. "Balo bền, ngăn laptop vừa 15.6 inch".

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=204, user_id='dddddddd-0004-4000-a000-000000000004', phone='0921234504', address_line='23 Điện Biên Phủ', city='Hải Phòng', district_id=7, state_id=4, country_id=1, is_default=true |
| cart | cart_item | customer_id='dddddddd-0004-4000-a000-000000000004', product_id=4, quantity=1 |
| order | checkout | id=54, customer_id='dddddddd-0004-4000-a000-000000000004', email='rate_hung@test.com', shipping_address_id=204, billing_address_id=204, total_amount=1890000, payment_method='COD' |
| order | order | id=54, checkout_id=54, customer_id='dddddddd-0004-4000-a000-000000000004', total_amount=1890000, order_status='COMPLETED' |
| rating | rating | id=4, customer_id='dddddddd-0004-4000-a000-000000000004', product_id=4, rating_stars=4, headline='Balo tốt', comment='Balo bền, ngăn laptop vừa 15.6 inch', created_by='dddddddd-0004-4000-a000-000000000004', order_id=54 |

Keycloak: `id=dddddddd-0004-4000-a000-000000000004, username=rate_hung, email=rate_hung@test.com, role=CUSTOMER`

---

### Scenario 5 — Hoang Thi Thu rates Trung Nguyen coffee ★★★★★

Thu bought 3 coffee bags (product_id=5). 5 stars. "Cà phê ngon đúng vị, thơm lâu".

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=205, user_id='dddddddd-0005-4000-a000-000000000005', phone='0921234505', address_line='56 Đường 3/2', city='Cần Thơ', district_id=9, state_id=5, country_id=1, is_default=true |
| cart | cart_item | customer_id='dddddddd-0005-4000-a000-000000000005', product_id=5, quantity=3 |
| order | checkout | id=55, customer_id='dddddddd-0005-4000-a000-000000000005', email='rate_thu@test.com', shipping_address_id=205, billing_address_id=205, total_amount=435000, payment_method='COD' |
| order | order | id=55, checkout_id=55, customer_id='dddddddd-0005-4000-a000-000000000005', total_amount=435000, order_status='COMPLETED' |
| rating | rating | id=5, customer_id='dddddddd-0005-4000-a000-000000000005', product_id=5, rating_stars=5, headline='Cà phê ngon', comment='Cà phê ngon đúng vị, thơm lâu', created_by='dddddddd-0005-4000-a000-000000000005', order_id=55 |

Keycloak: `id=dddddddd-0005-4000-a000-000000000005, username=rate_thu, email=rate_thu@test.com, role=CUSTOMER`

---

### Scenario 6 — Vo Van Thanh rates Apple Watch ★★★★★

Thanh bought Apple Watch SE 2nd Gen (product_id=6). 5 stars. "Đồng hồ chính hãng, pin trâu, giao nhanh".

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=206, user_id='dddddddd-0006-4000-a000-000000000006', phone='0921234506', address_line='34 Lê Lợi', city='Huế', district_id=11, state_id=6, country_id=1, is_default=true |
| cart | cart_item | customer_id='dddddddd-0006-4000-a000-000000000006', product_id=6, quantity=1 |
| order | checkout | id=56, customer_id='dddddddd-0006-4000-a000-000000000006', email='rate_thanh@test.com', shipping_address_id=206, billing_address_id=206, total_amount=7990000, payment_method='COD' |
| order | order | id=56, checkout_id=56, customer_id='dddddddd-0006-4000-a000-000000000006', total_amount=7990000, order_status='COMPLETED' |
| rating | rating | id=6, customer_id='dddddddd-0006-4000-a000-000000000006', product_id=6, rating_stars=5, headline='Chính hãng', comment='Đồng hồ chính hãng, pin trâu, giao nhanh', created_by='dddddddd-0006-4000-a000-000000000006', order_id=56 |

Keycloak: `id=dddddddd-0006-4000-a000-000000000006, username=rate_thanh, email=rate_thanh@test.com, role=CUSTOMER`

---

### Scenario 7 — Nguyen Thi Bich rates L'Oreal serum ★★★★

Bich bought 2 serums (product_id=7). 4 stars. "Serum thấm nhanh, da mềm hơn sau 2 tuần".

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=207, user_id='dddddddd-0007-4000-a000-000000000007', phone='0921234507', address_line='90 Trần Phú', city='Nha Trang', district_id=13, state_id=7, country_id=1, is_default=true |
| cart | cart_item | customer_id='dddddddd-0007-4000-a000-000000000007', product_id=7, quantity=2 |
| order | checkout | id=57, customer_id='dddddddd-0007-4000-a000-000000000007', email='rate_bich@test.com', shipping_address_id=207, billing_address_id=207, total_amount=840000, payment_method='BANK_TRANSFER' |
| order | order | id=57, checkout_id=57, customer_id='dddddddd-0007-4000-a000-000000000007', total_amount=840000, order_status='COMPLETED' |
| rating | rating | id=7, customer_id='dddddddd-0007-4000-a000-000000000007', product_id=7, rating_stars=4, headline='Serum tốt', comment='Serum thấm nhanh, da mềm hơn sau 2 tuần', created_by='dddddddd-0007-4000-a000-000000000007', order_id=57 |

Keycloak: `id=dddddddd-0007-4000-a000-000000000007, username=rate_bich, email=rate_bich@test.com, role=CUSTOMER`

---

### Scenario 8 — Do Manh Cuong rates Logitech headset ★★★★★

Cuong bought Logitech G435 (product_id=8). 5 stars. "Tai nghe nhẹ, âm thanh trong, kết nối ổn định".

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=208, user_id='dddddddd-0008-4000-a000-000000000008', phone='0921234508', address_line='15 Trần Hưng Đạo', city='Đà Lạt', district_id=15, state_id=8, country_id=1, is_default=true |
| cart | cart_item | customer_id='dddddddd-0008-4000-a000-000000000008', product_id=8, quantity=1 |
| order | checkout | id=58, customer_id='dddddddd-0008-4000-a000-000000000008', email='rate_cuong@test.com', shipping_address_id=208, billing_address_id=208, total_amount=1590000, payment_method='COD' |
| order | order | id=58, checkout_id=58, customer_id='dddddddd-0008-4000-a000-000000000008', total_amount=1590000, order_status='COMPLETED' |
| rating | rating | id=8, customer_id='dddddddd-0008-4000-a000-000000000008', product_id=8, rating_stars=5, headline='Tai nghe xịn', comment='Tai nghe nhẹ, âm thanh trong, kết nối ổn định', created_by='dddddddd-0008-4000-a000-000000000008', order_id=58 |

Keycloak: `id=dddddddd-0008-4000-a000-000000000008, username=rate_cuong, email=rate_cuong@test.com, role=CUSTOMER`

---

### Scenario 9 — Tran Thi Oanh rates Uji matcha ★★★★★

Oanh bought 2 matcha tins (product_id=9). 5 stars. "Matcha ceremonial grade chuẩn vị Nhật, màu xanh đẹp".

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=209, user_id='dddddddd-0009-4000-a000-000000000009', phone='0921234509', address_line='67 Thùy Vân', city='Vũng Tàu', district_id=17, state_id=9, country_id=1, is_default=true |
| cart | cart_item | customer_id='dddddddd-0009-4000-a000-000000000009', product_id=9, quantity=2 |
| order | checkout | id=59, customer_id='dddddddd-0009-4000-a000-000000000009', email='rate_oanh@test.com', shipping_address_id=209, billing_address_id=209, total_amount=760000, payment_method='COD' |
| order | order | id=59, checkout_id=59, customer_id='dddddddd-0009-4000-a000-000000000009', total_amount=760000, order_status='COMPLETED' |
| rating | rating | id=9, customer_id='dddddddd-0009-4000-a000-000000000009', product_id=9, rating_stars=5, headline='Matcha ngon', comment='Matcha ceremonial grade chuẩn vị Nhật, màu xanh đẹp', created_by='dddddddd-0009-4000-a000-000000000009', order_id=59 |

Keycloak: `id=dddddddd-0009-4000-a000-000000000009, username=rate_oanh, email=rate_oanh@test.com, role=CUSTOMER`

---

### Scenario 10 — Bui Van Duc rates Manduka yoga mat ★★★★★

Duc bought Manduka PRO (product_id=10). 5 stars. "Thảm dày, bám tốt, xứng đáng giá tiền".

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=210, user_id='dddddddd-0010-4000-a000-000000000010', phone='0921234510', address_line='88 Đồng Khởi', city='Biên Hòa', district_id=19, state_id=10, country_id=1, is_default=true |
| cart | cart_item | customer_id='dddddddd-0010-4000-a000-000000000010', product_id=10, quantity=1 |
| order | checkout | id=60, customer_id='dddddddd-0010-4000-a000-000000000010', email='rate_duc@test.com', shipping_address_id=210, billing_address_id=210, total_amount=2750000, payment_method='COD' |
| order | order | id=60, checkout_id=60, customer_id='dddddddd-0010-4000-a000-000000000010', total_amount=2750000, order_status='COMPLETED' |
| rating | rating | id=10, customer_id='dddddddd-0010-4000-a000-000000000010', product_id=10, rating_stars=5, headline='Thảm xịn', comment='Thảm dày, bám tốt, xứng đáng giá tiền', created_by='dddddddd-0010-4000-a000-000000000010', order_id=60 |

Keycloak: `id=dddddddd-0010-4000-a000-000000000010, username=rate_duc, email=rate_duc@test.com, role=CUSTOMER`

---

### Scenario 11 — Ly Thi Phuong rates Mango shirt ★★★★

Phuong bought Mango Linen S (product_id=11). 4 stars. "Áo đẹp, chất liệu thoáng mát, size chuẩn".

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=211, user_id='dddddddd-0011-4000-a000-000000000011', phone='0921234511', address_line='5 Chùa Láng', city='Hà Nội', district_id=2, state_id=1, country_id=1, is_default=true |
| cart | cart_item | customer_id='dddddddd-0011-4000-a000-000000000011', product_id=11, quantity=1 |
| order | checkout | id=61, customer_id='dddddddd-0011-4000-a000-000000000011', email='rate_phuong@test.com', shipping_address_id=211, billing_address_id=211, total_amount=790000, payment_method='COD' |
| order | order | id=61, checkout_id=61, customer_id='dddddddd-0011-4000-a000-000000000011', total_amount=790000, order_status='COMPLETED' |
| rating | rating | id=11, customer_id='dddddddd-0011-4000-a000-000000000011', product_id=11, rating_stars=4, headline='Áo đẹp', comment='Áo đẹp, chất liệu thoáng mát, size chuẩn', created_by='dddddddd-0011-4000-a000-000000000011', order_id=61 |

Keycloak: `id=dddddddd-0011-4000-a000-000000000011, username=rate_phuong, email=rate_phuong@test.com, role=CUSTOMER`

---

### Scenario 12 — Nguyen Van An rates Dyson vacuum ★★★★★

An bought Dyson V12 (product_id=12). 5 stars. "Máy hút mạnh, nhẹ tay, pin dùng được 60 phút".

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=212, user_id='dddddddd-0012-4000-a000-000000000012', phone='0921234512', address_line='101 Võ Thị Sáu', city='TP. Hồ Chí Minh', district_id=4, state_id=2, country_id=1, is_default=true |
| cart | cart_item | customer_id='dddddddd-0012-4000-a000-000000000012', product_id=12, quantity=1 |
| order | checkout | id=62, customer_id='dddddddd-0012-4000-a000-000000000012', email='rate_an@test.com', shipping_address_id=212, billing_address_id=212, total_amount=12990000, payment_method='BANK_TRANSFER' |
| order | order | id=62, checkout_id=62, customer_id='dddddddd-0012-4000-a000-000000000012', total_amount=12990000, order_status='COMPLETED' |
| rating | rating | id=12, customer_id='dddddddd-0012-4000-a000-000000000012', product_id=12, rating_stars=5, headline='Máy hút tuyệt vời', comment='Máy hút mạnh, nhẹ tay, pin dùng được 60 phút', created_by='dddddddd-0012-4000-a000-000000000012', order_id=62 |

Keycloak: `id=dddddddd-0012-4000-a000-000000000012, username=rate_an, email=rate_an@test.com, role=CUSTOMER`

---

### Scenario 13 — Dang Thi Lien rates Doraemon book ★★★★★

Lien bought 2 Doraemon (product_id=13). 5 stars. "Bản màu đặc biệt rất đẹp, cháu thích lắm".

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=213, user_id='dddddddd-0013-4000-a000-000000000013', phone='0921234513', address_line='32 Phạm Văn Đồng', city='Đà Nẵng', district_id=6, state_id=3, country_id=1, is_default=true |
| cart | cart_item | customer_id='dddddddd-0013-4000-a000-000000000013', product_id=13, quantity=2 |
| order | checkout | id=63, customer_id='dddddddd-0013-4000-a000-000000000013', email='rate_lien@test.com', shipping_address_id=213, billing_address_id=213, total_amount=136000, payment_method='COD' |
| order | order | id=63, checkout_id=63, customer_id='dddddddd-0013-4000-a000-000000000013', total_amount=136000, order_status='COMPLETED' |
| rating | rating | id=13, customer_id='dddddddd-0013-4000-a000-000000000013', product_id=13, rating_stars=5, headline='Sách đẹp', comment='Bản màu đặc biệt rất đẹp, cháu thích lắm', created_by='dddddddd-0013-4000-a000-000000000013', order_id=63 |

Keycloak: `id=dddddddd-0013-4000-a000-000000000013, username=rate_lien, email=rate_lien@test.com, role=CUSTOMER`

---

### Scenario 14 — Phan Thi Xuan rates Xiaomi lamp ★★★

Xuan bought Xiaomi LED 1S (product_id=14). 3 stars. "Đèn đẹp nhưng ứng dụng hay mất kết nối".

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=214, user_id='dddddddd-0014-4000-a000-000000000014', phone='0921234514', address_line='44 Lý Tự Trọng', city='Hải Phòng', district_id=8, state_id=4, country_id=1, is_default=true |
| cart | cart_item | customer_id='dddddddd-0014-4000-a000-000000000014', product_id=14, quantity=1 |
| order | checkout | id=64, customer_id='dddddddd-0014-4000-a000-000000000014', email='rate_xuan@test.com', shipping_address_id=214, billing_address_id=214, total_amount=690000, payment_method='COD' |
| order | order | id=64, checkout_id=64, customer_id='dddddddd-0014-4000-a000-000000000014', total_amount=690000, order_status='COMPLETED' |
| rating | rating | id=14, customer_id='dddddddd-0014-4000-a000-000000000014', product_id=14, rating_stars=3, headline='Tạm ổn', comment='Đèn đẹp nhưng ứng dụng hay mất kết nối', created_by='dddddddd-0014-4000-a000-000000000014', order_id=64 |

Keycloak: `id=dddddddd-0014-4000-a000-000000000014, username=rate_xuan, email=rate_xuan@test.com, role=CUSTOMER`

---

### Scenario 15 — Truong Van Long rates JJ cutting board ★★★★

Long bought JJ Folio 4-piece (product_id=15). 4 stars. "Thớt tre chắc, dễ rửa, kích thước hợp lý".

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=215, user_id='dddddddd-0015-4000-a000-000000000015', phone='0921234515', address_line='19 Nguyễn Văn Cừ', city='Cần Thơ', district_id=10, state_id=5, country_id=1, is_default=true |
| cart | cart_item | customer_id='dddddddd-0015-4000-a000-000000000015', product_id=15, quantity=1 |
| order | checkout | id=65, customer_id='dddddddd-0015-4000-a000-000000000015', email='rate_long@test.com', shipping_address_id=215, billing_address_id=215, total_amount=850000, payment_method='COD' |
| order | order | id=65, checkout_id=65, customer_id='dddddddd-0015-4000-a000-000000000015', total_amount=850000, order_status='COMPLETED' |
| rating | rating | id=15, customer_id='dddddddd-0015-4000-a000-000000000015', product_id=15, rating_stars=4, headline='Thớt tốt', comment='Thớt tre chắc, dễ rửa, kích thước hợp lý', created_by='dddddddd-0015-4000-a000-000000000015', order_id=65 |

Keycloak: `id=dddddddd-0015-4000-a000-000000000015, username=rate_long, email=rate_long@test.com, role=CUSTOMER`

---

### Scenario 16 — Cao Thi Nga rates Now vitamins ★★★★★

Nga bought 2 Now Vitamin C (product_id=16). 5 stars. "Viên uống dễ, không đau bao tử, giao đóng gói kỹ".

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=216, user_id='dddddddd-0016-4000-a000-000000000016', phone='0921234516', address_line='7 Hai Bà Trưng', city='Huế', district_id=12, state_id=6, country_id=1, is_default=true |
| cart | cart_item | customer_id='dddddddd-0016-4000-a000-000000000016', product_id=16, quantity=2 |
| order | checkout | id=66, customer_id='dddddddd-0016-4000-a000-000000000016', email='rate_nga@test.com', shipping_address_id=216, billing_address_id=216, total_amount=620000, payment_method='COD' |
| order | order | id=66, checkout_id=66, customer_id='dddddddd-0016-4000-a000-000000000016', total_amount=620000, order_status='COMPLETED' |
| rating | rating | id=16, customer_id='dddddddd-0016-4000-a000-000000000016', product_id=16, rating_stars=5, headline='Vitamin tốt', comment='Viên uống dễ, không đau bao tử, giao đóng gói kỹ', created_by='dddddddd-0016-4000-a000-000000000016', order_id=66 |

Keycloak: `id=dddddddd-0016-4000-a000-000000000016, username=rate_nga, email=rate_nga@test.com, role=CUSTOMER`

---

### Scenario 17 — Mai Van Son rates Keychron keyboard ★★★★★

Son bought Keychron K2 Pro (product_id=17). 5 stars. "Bàn phím cơ xịn nhất tầm giá, switch Red gõ nhẹ tay".

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=217, user_id='dddddddd-0017-4000-a000-000000000017', phone='0921234517', address_line='25 Nguyễn Thiện Thuật', city='Nha Trang', district_id=14, state_id=7, country_id=1, is_default=true |
| cart | cart_item | customer_id='dddddddd-0017-4000-a000-000000000017', product_id=17, quantity=1 |
| order | checkout | id=67, customer_id='dddddddd-0017-4000-a000-000000000017', email='rate_son@test.com', shipping_address_id=217, billing_address_id=217, total_amount=2490000, payment_method='BANK_TRANSFER' |
| order | order | id=67, checkout_id=67, customer_id='dddddddd-0017-4000-a000-000000000017', total_amount=2490000, order_status='COMPLETED' |
| rating | rating | id=17, customer_id='dddddddd-0017-4000-a000-000000000017', product_id=17, rating_stars=5, headline='Bàn phím tốt nhất', comment='Bàn phím cơ xịn nhất tầm giá, switch Red gõ nhẹ tay', created_by='dddddddd-0017-4000-a000-000000000017', order_id=67 |

Keycloak: `id=dddddddd-0017-4000-a000-000000000017, username=rate_son, email=rate_son@test.com, role=CUSTOMER`

---

### Scenario 18 — Vo Thi Kim rates Khaisilk scarf ★★★★★

Kim bought Khaisilk Floral (product_id=18). 5 stars. "Khăn lụa đẹp, họa tiết vẽ tay tinh tế, làm quà rất ý nghĩa".

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=218, user_id='dddddddd-0018-4000-a000-000000000018', phone='0921234518', address_line='38 Phan Đình Phùng', city='Đà Lạt', district_id=16, state_id=8, country_id=1, is_default=true |
| cart | cart_item | customer_id='dddddddd-0018-4000-a000-000000000018', product_id=18, quantity=1 |
| order | checkout | id=68, customer_id='dddddddd-0018-4000-a000-000000000018', email='rate_kim@test.com', shipping_address_id=218, billing_address_id=218, total_amount=1200000, payment_method='COD' |
| order | order | id=68, checkout_id=68, customer_id='dddddddd-0018-4000-a000-000000000018', total_amount=1200000, order_status='COMPLETED' |
| rating | rating | id=18, customer_id='dddddddd-0018-4000-a000-000000000018', product_id=18, rating_stars=5, headline='Khăn lụa tuyệt', comment='Khăn lụa đẹp, họa tiết vẽ tay tinh tế, làm quà rất ý nghĩa', created_by='dddddddd-0018-4000-a000-000000000018', order_id=68 |

Keycloak: `id=dddddddd-0018-4000-a000-000000000018, username=rate_kim, email=rate_kim@test.com, role=CUSTOMER`

---

### Scenario 19 — Nguyen Duc Tuan rates JBL Flip 6 ★★★★★

Tuan bought JBL Flip 6 (product_id=19). 5 stars. "Loa bass mạnh, chống nước tốt, âm thanh 360 độ".

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=219, user_id='dddddddd-0019-4000-a000-000000000019', phone='0921234519', address_line='52 Nam Kỳ Khởi Nghĩa', city='Vũng Tàu', district_id=18, state_id=9, country_id=1, is_default=true |
| cart | cart_item | customer_id='dddddddd-0019-4000-a000-000000000019', product_id=19, quantity=1 |
| order | checkout | id=69, customer_id='dddddddd-0019-4000-a000-000000000019', email='rate_tuan@test.com', shipping_address_id=219, billing_address_id=219, total_amount=2990000, payment_method='COD' |
| order | order | id=69, checkout_id=69, customer_id='dddddddd-0019-4000-a000-000000000019', total_amount=2990000, order_status='COMPLETED' |
| rating | rating | id=19, customer_id='dddddddd-0019-4000-a000-000000000019', product_id=19, rating_stars=5, headline='Loa hay nhất', comment='Loa bass mạnh, chống nước tốt, âm thanh 360 độ', created_by='dddddddd-0019-4000-a000-000000000019', order_id=69 |

Keycloak: `id=dddddddd-0019-4000-a000-000000000019, username=rate_tuan, email=rate_tuan@test.com, role=CUSTOMER`

---

### Scenario 20 — Le Van Hai rates succulent pot ★★★★

Hai bought 3 Haworthia pots (product_id=20). 4 stars. "Cây khỏe mạnh, chậu gốm đẹp, đóng gói cẩn thận".

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=220, user_id='dddddddd-0020-4000-a000-000000000020', phone='0921234520', address_line='77 Cách Mạng Tháng 8', city='Biên Hòa', district_id=20, state_id=10, country_id=1, is_default=true |
| cart | cart_item | customer_id='dddddddd-0020-4000-a000-000000000020', product_id=20, quantity=3 |
| order | checkout | id=70, customer_id='dddddddd-0020-4000-a000-000000000020', email='rate_hai@test.com', shipping_address_id=220, billing_address_id=220, total_amount=285000, payment_method='COD' |
| order | order | id=70, checkout_id=70, customer_id='dddddddd-0020-4000-a000-000000000020', total_amount=285000, order_status='COMPLETED' |
| rating | rating | id=20, customer_id='dddddddd-0020-4000-a000-000000000020', product_id=20, rating_stars=4, headline='Cây đẹp', comment='Cây khỏe mạnh, chậu gốm đẹp, đóng gói cẩn thận', created_by='dddddddd-0020-4000-a000-000000000020', order_id=70 |

Keycloak: `id=dddddddd-0020-4000-a000-000000000020, username=rate_hai, email=rate_hai@test.com, role=CUSTOMER`

---

### Scenario 21 — Dinh Thi Huyen rates Cuckoo rice cooker ★★★★★

Huyen bought Cuckoo CRP-P0609S (product_id=21). 5 stars. "Cơm ngon, áp suất đều, màn hình tiếng Việt".

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=221, user_id='dddddddd-0021-4000-a000-000000000021', phone='0921234521', address_line='3 Đinh Tiên Hoàng', city='Hà Nội', district_id=1, state_id=1, country_id=1, is_default=true |
| cart | cart_item | customer_id='dddddddd-0021-4000-a000-000000000021', product_id=21, quantity=1 |
| order | checkout | id=71, customer_id='dddddddd-0021-4000-a000-000000000021', email='rate_huyen@test.com', shipping_address_id=221, billing_address_id=221, total_amount=5490000, payment_method='BANK_TRANSFER' |
| order | order | id=71, checkout_id=71, customer_id='dddddddd-0021-4000-a000-000000000021', total_amount=5490000, order_status='COMPLETED' |
| rating | rating | id=21, customer_id='dddddddd-0021-4000-a000-000000000021', product_id=21, rating_stars=5, headline='Nồi hoàn hảo', comment='Cơm ngon, áp suất đều, màn hình tiếng Việt', created_by='dddddddd-0021-4000-a000-000000000021', order_id=71 |

Keycloak: `id=dddddddd-0021-4000-a000-000000000021, username=rate_huyen, email=rate_huyen@test.com, role=CUSTOMER`

---

### Scenario 22 — Ngo Van Cuong rates Shimano fishing combo ★★★★

Cuong bought Shimano Sienna (product_id=22). 4 stars. "Máy cuốn trơn, cần dẻo, rất phù hợp người mới".

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=222, user_id='dddddddd-0022-4000-a000-000000000022', phone='0921234522', address_line='200 Lý Chính Thắng', city='TP. Hồ Chí Minh', district_id=3, state_id=2, country_id=1, is_default=true |
| cart | cart_item | customer_id='dddddddd-0022-4000-a000-000000000022', product_id=22, quantity=1 |
| order | checkout | id=72, customer_id='dddddddd-0022-4000-a000-000000000022', email='rate_cuong2@test.com', shipping_address_id=222, billing_address_id=222, total_amount=890000, payment_method='COD' |
| order | order | id=72, checkout_id=72, customer_id='dddddddd-0022-4000-a000-000000000022', total_amount=890000, order_status='COMPLETED' |
| rating | rating | id=22, customer_id='dddddddd-0022-4000-a000-000000000022', product_id=22, rating_stars=4, headline='Bộ câu tốt', comment='Máy cuốn trơn, cần dẻo, rất phù hợp người mới', created_by='dddddddd-0022-4000-a000-000000000022', order_id=72 |

Keycloak: `id=dddddddd-0022-4000-a000-000000000022, username=rate_cuong2, email=rate_cuong2@test.com, role=CUSTOMER`

---

### Scenario 23 — Pham Thi Mai rates COSRX toner ★★★★★

Mai bought 2 COSRX toners (product_id=23). 5 stars. "Toner dịu nhẹ, lỗ chân lông thu nhỏ, mụn giảm rõ rệt".

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=223, user_id='dddddddd-0023-4000-a000-000000000023', phone='0921234523', address_line='16 Trần Phú', city='Đà Nẵng', district_id=5, state_id=3, country_id=1, is_default=true |
| cart | cart_item | customer_id='dddddddd-0023-4000-a000-000000000023', product_id=23, quantity=2 |
| order | checkout | id=73, customer_id='dddddddd-0023-4000-a000-000000000023', email='rate_mai@test.com', shipping_address_id=223, billing_address_id=223, total_amount=570000, payment_method='COD' |
| order | order | id=73, checkout_id=73, customer_id='dddddddd-0023-4000-a000-000000000023', total_amount=570000, order_status='COMPLETED' |
| rating | rating | id=23, customer_id='dddddddd-0023-4000-a000-000000000023', product_id=23, rating_stars=5, headline='Toner hiệu quả', comment='Toner dịu nhẹ, lỗ chân lông thu nhỏ, mụn giảm rõ rệt', created_by='dddddddd-0023-4000-a000-000000000023', order_id=73 |

Keycloak: `id=dddddddd-0023-4000-a000-000000000023, username=rate_mai, email=rate_mai@test.com, role=CUSTOMER`

---

### Scenario 24 — Tran Duc Khanh rates Garmin cable ★★★★

Khanh bought Garmin FR255 charger (product_id=24). 4 stars. "Cáp sạc nhanh, khớp vừa đồng hồ, dây hơi ngắn".

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=224, user_id='dddddddd-0024-4000-a000-000000000024', phone='0921234524', address_line='60 Tô Hiệu', city='Hải Phòng', district_id=7, state_id=4, country_id=1, is_default=true |
| cart | cart_item | customer_id='dddddddd-0024-4000-a000-000000000024', product_id=24, quantity=1 |
| order | checkout | id=74, customer_id='dddddddd-0024-4000-a000-000000000024', email='rate_khanh@test.com', shipping_address_id=224, billing_address_id=224, total_amount=290000, payment_method='COD' |
| order | order | id=74, checkout_id=74, customer_id='dddddddd-0024-4000-a000-000000000024', total_amount=290000, order_status='COMPLETED' |
| rating | rating | id=24, customer_id='dddddddd-0024-4000-a000-000000000024', product_id=24, rating_stars=4, headline='Cáp ổn', comment='Cáp sạc nhanh, khớp vừa đồng hồ, dây hơi ngắn', created_by='dddddddd-0024-4000-a000-000000000024', order_id=74 |

Keycloak: `id=dddddddd-0024-4000-a000-000000000024, username=rate_khanh, email=rate_khanh@test.com, role=CUSTOMER`

---

### Scenario 25 — Bui Thi Lan rates Tefal pan ★★★★★

Lan bought Tefal ECC 28cm (product_id=25). 5 stars. "Chảo chống dính tốt, rửa dễ, tay cầm vững".

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=225, user_id='dddddddd-0025-4000-a000-000000000025', phone='0921234525', address_line='9 Hoà Bình', city='Cần Thơ', district_id=9, state_id=5, country_id=1, is_default=true |
| cart | cart_item | customer_id='dddddddd-0025-4000-a000-000000000025', product_id=25, quantity=1 |
| order | checkout | id=75, customer_id='dddddddd-0025-4000-a000-000000000025', email='rate_lan2@test.com', shipping_address_id=225, billing_address_id=225, total_amount=690000, payment_method='COD' |
| order | order | id=75, checkout_id=75, customer_id='dddddddd-0025-4000-a000-000000000025', total_amount=690000, order_status='COMPLETED' |
| rating | rating | id=25, customer_id='dddddddd-0025-4000-a000-000000000025', product_id=25, rating_stars=5, headline='Chảo tốt', comment='Chảo chống dính tốt, rửa dễ, tay cầm vững', created_by='dddddddd-0025-4000-a000-000000000025', order_id=75 |

Keycloak: `id=dddddddd-0025-4000-a000-000000000025, username=rate_lan2, email=rate_lan2@test.com, role=CUSTOMER`

---

### Scenario 26 — Hoang Van Binh rates Lacoste polo ★★★★

Binh bought Lacoste Classic Polo M (product_id=26). 4 stars. "Áo polo chuẩn, vải co giãn tốt, logo thêu sắc nét".

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=226, user_id='dddddddd-0026-4000-a000-000000000026', phone='0921234526', address_line='41 Nguyễn Trãi', city='Huế', district_id=11, state_id=6, country_id=1, is_default=true |
| cart | cart_item | customer_id='dddddddd-0026-4000-a000-000000000026', product_id=26, quantity=1 |
| order | checkout | id=76, customer_id='dddddddd-0026-4000-a000-000000000026', email='rate_binh@test.com', shipping_address_id=226, billing_address_id=226, total_amount=1850000, payment_method='BANK_TRANSFER' |
| order | order | id=76, checkout_id=76, customer_id='dddddddd-0026-4000-a000-000000000026', total_amount=1850000, order_status='COMPLETED' |
| rating | rating | id=26, customer_id='dddddddd-0026-4000-a000-000000000026', product_id=26, rating_stars=4, headline='Polo chuẩn', comment='Áo polo chuẩn, vải co giãn tốt, logo thêu sắc nét', created_by='dddddddd-0026-4000-a000-000000000026', order_id=76 |

Keycloak: `id=dddddddd-0026-4000-a000-000000000026, username=rate_binh, email=rate_binh@test.com, role=CUSTOMER`

---

### Scenario 27 — Nguyen Thi Thanh Thuy rates kids bike ★★★★★

Thuy bought Giant ARX 20 (product_id=27). 5 stars. "Con trai thích mê, xe chắc chắn, phanh tốt, lắp dễ".

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=227, user_id='dddddddd-0027-4000-a000-000000000027', phone='0921234527', address_line='73 Nguyễn Đình Chiểu', city='Nha Trang', district_id=13, state_id=7, country_id=1, is_default=true |
| cart | cart_item | customer_id='dddddddd-0027-4000-a000-000000000027', product_id=27, quantity=1 |
| order | checkout | id=77, customer_id='dddddddd-0027-4000-a000-000000000027', email='rate_thuy@test.com', shipping_address_id=227, billing_address_id=227, total_amount=4290000, payment_method='BANK_TRANSFER' |
| order | order | id=77, checkout_id=77, customer_id='dddddddd-0027-4000-a000-000000000027', total_amount=4290000, order_status='COMPLETED' |
| rating | rating | id=27, customer_id='dddddddd-0027-4000-a000-000000000027', product_id=27, rating_stars=5, headline='Xe đẹp', comment='Con trai thích mê, xe chắc chắn, phanh tốt, lắp dễ', created_by='dddddddd-0027-4000-a000-000000000027', order_id=77 |

Keycloak: `id=dddddddd-0027-4000-a000-000000000027, username=rate_thuy, email=rate_thuy@test.com, role=CUSTOMER`

---

### Scenario 28 — Le Hoang Nam rates Anker power bank ★★★★★

Nam bought Anker 20000mAh (product_id=28). 5 stars. "Sạc nhanh PD, dung lượng thực tế đúng, thiết kế gọn".

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=228, user_id='dddddddd-0028-4000-a000-000000000028', phone='0921234528', address_line='22 Đinh Tiên Hoàng', city='Đà Lạt', district_id=15, state_id=8, country_id=1, is_default=true |
| cart | cart_item | customer_id='dddddddd-0028-4000-a000-000000000028', product_id=28, quantity=1 |
| order | checkout | id=78, customer_id='dddddddd-0028-4000-a000-000000000028', email='rate_nam@test.com', shipping_address_id=228, billing_address_id=228, total_amount=1090000, payment_method='COD' |
| order | order | id=78, checkout_id=78, customer_id='dddddddd-0028-4000-a000-000000000028', total_amount=1090000, order_status='COMPLETED' |
| rating | rating | id=28, customer_id='dddddddd-0028-4000-a000-000000000028', product_id=28, rating_stars=5, headline='Pin trâu', comment='Sạc nhanh PD, dung lượng thực tế đúng, thiết kế gọn', created_by='dddddddd-0028-4000-a000-000000000028', order_id=78 |

Keycloak: `id=dddddddd-0028-4000-a000-000000000028, username=rate_nam, email=rate_nam@test.com, role=CUSTOMER`

---

### Scenario 29 — Tran Thi Quynh rates puzzle ★★★★

Quynh bought Ravensburger Hoi An 1000p (product_id=29). 4 stars. "Hình ảnh đẹp, mảnh ghép vừa khít, hoàn thành mất 3 buổi".

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=229, user_id='dddddddd-0029-4000-a000-000000000029', phone='0921234529', address_line='85 Lý Thường Kiệt', city='Vũng Tàu', district_id=17, state_id=9, country_id=1, is_default=true |
| cart | cart_item | customer_id='dddddddd-0029-4000-a000-000000000029', product_id=29, quantity=1 |
| order | checkout | id=79, customer_id='dddddddd-0029-4000-a000-000000000029', email='rate_quynh@test.com', shipping_address_id=229, billing_address_id=229, total_amount=395000, payment_method='COD' |
| order | order | id=79, checkout_id=79, customer_id='dddddddd-0029-4000-a000-000000000029', total_amount=395000, order_status='COMPLETED' |
| rating | rating | id=29, customer_id='dddddddd-0029-4000-a000-000000000029', product_id=29, rating_stars=4, headline='Puzzle vui', comment='Hình ảnh đẹp, mảnh ghép vừa khít, hoàn thành mất 3 buổi', created_by='dddddddd-0029-4000-a000-000000000029', order_id=79 |

Keycloak: `id=dddddddd-0029-4000-a000-000000000029, username=rate_quynh, email=rate_quynh@test.com, role=CUSTOMER`

---

### Scenario 30 — Vu Thi Thu Hang rates Chanel perfume ★★★★★

Hang bought Chanel Chance Tendre (product_id=30). 5 stars. "Nước hoa chính hãng, hương thơm sang trọng, lưu hương lâu".

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=230, user_id='dddddddd-0030-4000-a000-000000000030', phone='0921234530', address_line='14 Phạm Văn Thuận', city='Biên Hòa', district_id=19, state_id=10, country_id=1, is_default=true |
| cart | cart_item | customer_id='dddddddd-0030-4000-a000-000000000030', product_id=30, quantity=1 |
| order | checkout | id=80, customer_id='dddddddd-0030-4000-a000-000000000030', email='rate_hang@test.com', shipping_address_id=230, billing_address_id=230, total_amount=4500000, payment_method='BANK_TRANSFER' |
| order | order | id=80, checkout_id=80, customer_id='dddddddd-0030-4000-a000-000000000030', total_amount=4500000, order_status='COMPLETED' |
| rating | rating | id=30, customer_id='dddddddd-0030-4000-a000-000000000030', product_id=30, rating_stars=5, headline='Nước hoa sang', comment='Nước hoa chính hãng, hương thơm sang trọng, lưu hương lâu', created_by='dddddddd-0030-4000-a000-000000000030', order_id=80 |

Keycloak: `id=dddddddd-0030-4000-a000-000000000030, username=rate_hang, email=rate_hang@test.com, role=CUSTOMER`

---

### Scenario 31 — Nguyen Van Hieu rates TP-Link router ★★★★

Hieu bought TP-Link AX73 (product_id=31). 4 stars. "WiFi 6 mạnh, phủ sóng tốt 3 tầng, cài đặt dễ qua app".

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=231, user_id='dddddddd-0031-4000-a000-000000000031', phone='0921234531', address_line='91 Khâm Thiên', city='Hà Nội', district_id=2, state_id=1, country_id=1, is_default=true |
| cart | cart_item | customer_id='dddddddd-0031-4000-a000-000000000031', product_id=31, quantity=1 |
| order | checkout | id=81, customer_id='dddddddd-0031-4000-a000-000000000031', email='rate_hieu@test.com', shipping_address_id=231, billing_address_id=231, total_amount=3490000, payment_method='BANK_TRANSFER' |
| order | order | id=81, checkout_id=81, customer_id='dddddddd-0031-4000-a000-000000000031', total_amount=3490000, order_status='COMPLETED' |
| rating | rating | id=31, customer_id='dddddddd-0031-4000-a000-000000000031', product_id=31, rating_stars=4, headline='Router mạnh', comment='WiFi 6 mạnh, phủ sóng tốt 3 tầng, cài đặt dễ qua app', created_by='dddddddd-0031-4000-a000-000000000031', order_id=81 |

Keycloak: `id=dddddddd-0031-4000-a000-000000000031, username=rate_hieu, email=rate_hieu@test.com, role=CUSTOMER`

---

### Scenario 32 — Trinh Thi Nga rates essential oil ★★★★★

Nga bought 3 Plant Therapy Lavender (product_id=32). 5 stars. "Tinh dầu 100% nguyên chất, thư giãn tốt, giá hợp lý".

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=232, user_id='dddddddd-0032-4000-a000-000000000032', phone='0921234532', address_line='37 Nam Kỳ Khởi Nghĩa', city='TP. Hồ Chí Minh', district_id=4, state_id=2, country_id=1, is_default=true |
| cart | cart_item | customer_id='dddddddd-0032-4000-a000-000000000032', product_id=32, quantity=3 |
| order | checkout | id=82, customer_id='dddddddd-0032-4000-a000-000000000032', email='rate_nga2@test.com', shipping_address_id=232, billing_address_id=232, total_amount=840000, payment_method='COD' |
| order | order | id=82, checkout_id=82, customer_id='dddddddd-0032-4000-a000-000000000032', total_amount=840000, order_status='COMPLETED' |
| rating | rating | id=32, customer_id='dddddddd-0032-4000-a000-000000000032', product_id=32, rating_stars=5, headline='Tinh dầu thật', comment='Tinh dầu 100% nguyên chất, thư giãn tốt, giá hợp lý', created_by='dddddddd-0032-4000-a000-000000000032', order_id=82 |

Keycloak: `id=dddddddd-0032-4000-a000-000000000032, username=rate_nga2, email=rate_nga2@test.com, role=CUSTOMER`

---

### Scenario 33 — Pham Van Tung rates ON whey protein ★★★★★

Tung bought ON Gold Standard (product_id=33). 5 stars. "Protein tan nhanh, vị chocolate ngon, không bị đầy bụng".

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=233, user_id='dddddddd-0033-4000-a000-000000000033', phone='0921234533', address_line='55 Võ Nguyên Giáp', city='Đà Nẵng', district_id=6, state_id=3, country_id=1, is_default=true |
| cart | cart_item | customer_id='dddddddd-0033-4000-a000-000000000033', product_id=33, quantity=1 |
| order | checkout | id=83, customer_id='dddddddd-0033-4000-a000-000000000033', email='rate_tung@test.com', shipping_address_id=233, billing_address_id=233, total_amount=1190000, payment_method='COD' |
| order | order | id=83, checkout_id=83, customer_id='dddddddd-0033-4000-a000-000000000033', total_amount=1190000, order_status='COMPLETED' |
| rating | rating | id=33, customer_id='dddddddd-0033-4000-a000-000000000033', product_id=33, rating_stars=5, headline='Protein ngon', comment='Protein tan nhanh, vị chocolate ngon, không bị đầy bụng', created_by='dddddddd-0033-4000-a000-000000000033', order_id=83 |

Keycloak: `id=dddddddd-0033-4000-a000-000000000033, username=rate_tung, email=rate_tung@test.com, role=CUSTOMER`

---

### Scenario 34 — Hoang Thi Bao Ngoc rates Hobonichi planner ★★★★★

Ngoc bought Hobonichi A6 2025 (product_id=34). 5 stars. "Sổ tay chất lượng Nhật, giấy Tomoe River, kích thước vừa tay".

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=234, user_id='dddddddd-0034-4000-a000-000000000034', phone='0921234534', address_line='18 Quang Trung', city='Hải Phòng', district_id=8, state_id=4, country_id=1, is_default=true |
| cart | cart_item | customer_id='dddddddd-0034-4000-a000-000000000034', product_id=34, quantity=1 |
| order | checkout | id=84, customer_id='dddddddd-0034-4000-a000-000000000034', email='rate_ngoc@test.com', shipping_address_id=234, billing_address_id=234, total_amount=890000, payment_method='COD' |
| order | order | id=84, checkout_id=84, customer_id='dddddddd-0034-4000-a000-000000000034', total_amount=890000, order_status='COMPLETED' |
| rating | rating | id=34, customer_id='dddddddd-0034-4000-a000-000000000034', product_id=34, rating_stars=5, headline='Sổ đẹp', comment='Sổ tay chất lượng Nhật, giấy Tomoe River, kích thước vừa tay', created_by='dddddddd-0034-4000-a000-000000000034', order_id=84 |

Keycloak: `id=dddddddd-0034-4000-a000-000000000034, username=rate_ngoc, email=rate_ngoc@test.com, role=CUSTOMER`

---

### Scenario 35 — Nguyen Thi Diem rates Anessa sunscreen ★★★★★

Diem bought 4 Anessa SPF50+ (product_id=35). 5 stars. "Kem chống nắng nhẹ, không bị trắng da, cung cấp ẩm tốt".

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=235, user_id='dddddddd-0035-4000-a000-000000000035', phone='0921234535', address_line='63 Mậu Thân', city='Cần Thơ', district_id=10, state_id=5, country_id=1, is_default=true |
| cart | cart_item | customer_id='dddddddd-0035-4000-a000-000000000035', product_id=35, quantity=4 |
| order | checkout | id=85, customer_id='dddddddd-0035-4000-a000-000000000035', email='rate_diem@test.com', shipping_address_id=235, billing_address_id=235, total_amount=2480000, payment_method='COD' |
| order | order | id=85, checkout_id=85, customer_id='dddddddd-0035-4000-a000-000000000035', total_amount=2480000, order_status='COMPLETED' |
| rating | rating | id=35, customer_id='dddddddd-0035-4000-a000-000000000035', product_id=35, rating_stars=5, headline='Kem tốt nhất', comment='Kem chống nắng nhẹ, không bị trắng da, cung cấp ẩm tốt', created_by='dddddddd-0035-4000-a000-000000000035', order_id=85 |

Keycloak: `id=dddddddd-0035-4000-a000-000000000035, username=rate_diem, email=rate_diem@test.com, role=CUSTOMER`

---

### Scenario 36 — Dao Van Kien rates Spigen case ★★★★

Kien bought Spigen Ultra Hybrid (product_id=36). 4 stars. "Ốp trong suốt không ố vàng, bảo vệ góc máy tốt".

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=236, user_id='dddddddd-0036-4000-a000-000000000036', phone='0921234536', address_line='28 Trần Cao Vân', city='Huế', district_id=12, state_id=6, country_id=1, is_default=true |
| cart | cart_item | customer_id='dddddddd-0036-4000-a000-000000000036', product_id=36, quantity=1 |
| order | checkout | id=86, customer_id='dddddddd-0036-4000-a000-000000000036', email='rate_kien@test.com', shipping_address_id=236, billing_address_id=236, total_amount=395000, payment_method='COD' |
| order | order | id=86, checkout_id=86, customer_id='dddddddd-0036-4000-a000-000000000036', total_amount=395000, order_status='COMPLETED' |
| rating | rating | id=36, customer_id='dddddddd-0036-4000-a000-000000000036', product_id=36, rating_stars=4, headline='Ốp tốt', comment='Ốp trong suốt không ố vàng, bảo vệ góc máy tốt', created_by='dddddddd-0036-4000-a000-000000000036', order_id=86 |

Keycloak: `id=dddddddd-0036-4000-a000-000000000036, username=rate_kien, email=rate_kien@test.com, role=CUSTOMER`

---

### Scenario 37 — Luong Thi Thao rates Dyson hair dryer ★★★★★

Thao bought Dyson Supersonic (product_id=37). 5 stars. "Máy sấy nhẹ, không rụng tóc, sấy nhanh 10 phút".

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=237, user_id='dddddddd-0037-4000-a000-000000000037', phone='0921234537', address_line='47 Ngô Gia Tự', city='Nha Trang', district_id=14, state_id=7, country_id=1, is_default=true |
| cart | cart_item | customer_id='dddddddd-0037-4000-a000-000000000037', product_id=37, quantity=1 |
| order | checkout | id=87, customer_id='dddddddd-0037-4000-a000-000000000037', email='rate_thao@test.com', shipping_address_id=237, billing_address_id=237, total_amount=16500000, payment_method='BANK_TRANSFER' |
| order | order | id=87, checkout_id=87, customer_id='dddddddd-0037-4000-a000-000000000037', total_amount=16500000, order_status='COMPLETED' |
| rating | rating | id=37, customer_id='dddddddd-0037-4000-a000-000000000037', product_id=37, rating_stars=5, headline='Máy sấy tuyệt', comment='Máy sấy nhẹ, không rụng tóc, sấy nhanh 10 phút', created_by='dddddddd-0037-4000-a000-000000000037', order_id=87 |

Keycloak: `id=dddddddd-0037-4000-a000-000000000037, username=rate_thao, email=rate_thao@test.com, role=CUSTOMER`

---

### Scenario 38 — Do Van Thanh rates Trtl travel pillow ★★★★

Thanh bought Trtl Plus Navy (product_id=38). 4 stars. "Gối đỡ cổ tốt, ngủ ngon trên máy bay, hơi nóng khi đội lâu".

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=238, user_id='dddddddd-0038-4000-a000-000000000038', phone='0921234538', address_line='11 Lý Tự Trọng', city='Đà Lạt', district_id=16, state_id=8, country_id=1, is_default=true |
| cart | cart_item | customer_id='dddddddd-0038-4000-a000-000000000038', product_id=38, quantity=1 |
| order | checkout | id=88, customer_id='dddddddd-0038-4000-a000-000000000038', email='rate_thanh2@test.com', shipping_address_id=238, billing_address_id=238, total_amount=790000, payment_method='COD' |
| order | order | id=88, checkout_id=88, customer_id='dddddddd-0038-4000-a000-000000000038', total_amount=790000, order_status='COMPLETED' |
| rating | rating | id=38, customer_id='dddddddd-0038-4000-a000-000000000038', product_id=38, rating_stars=4, headline='Gối tốt', comment='Gối đỡ cổ tốt, ngủ ngon trên máy bay, hơi nóng khi đội lâu', created_by='dddddddd-0038-4000-a000-000000000038', order_id=88 |

Keycloak: `id=dddddddd-0038-4000-a000-000000000038, username=rate_thanh2, email=rate_thanh2@test.com, role=CUSTOMER`

---

### Scenario 39 — Nguyen Thi Hong rates waffle maker ★★★★★

Hong bought Cuisinart WMB-4 (product_id=39). 5 stars. "Waffle giòn đều, không dính, dễ vệ sinh mặt nướng".

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=239, user_id='dddddddd-0039-4000-a000-000000000039', phone='0921234539', address_line='99 Lê Hồng Phong', city='Vũng Tàu', district_id=18, state_id=9, country_id=1, is_default=true |
| cart | cart_item | customer_id='dddddddd-0039-4000-a000-000000000039', product_id=39, quantity=1 |
| order | checkout | id=89, customer_id='dddddddd-0039-4000-a000-000000000039', email='rate_hong@test.com', shipping_address_id=239, billing_address_id=239, total_amount=1490000, payment_method='COD' |
| order | order | id=89, checkout_id=89, customer_id='dddddddd-0039-4000-a000-000000000039', total_amount=1490000, order_status='COMPLETED' |
| rating | rating | id=39, customer_id='dddddddd-0039-4000-a000-000000000039', product_id=39, rating_stars=5, headline='Máy waffle tốt', comment='Waffle giòn đều, không dính, dễ vệ sinh mặt nướng', created_by='dddddddd-0039-4000-a000-000000000039', order_id=89 |

Keycloak: `id=dddddddd-0039-4000-a000-000000000039, username=rate_hong, email=rate_hong@test.com, role=CUSTOMER`

---

### Scenario 40 — Tran Quoc Bao rates Wacom drawing tablet ★★★★★

Bao bought Wacom Intuos Small Wireless (product_id=40). 5 stars. "Bảng vẽ nhạy, kết nối Bluetooth ổn định, driver cài dễ".

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=240, user_id='dddddddd-0040-4000-a000-000000000040', phone='0921234540', address_line='50 Lê Duẩn', city='Biên Hòa', district_id=20, state_id=10, country_id=1, is_default=true |
| cart | cart_item | customer_id='dddddddd-0040-4000-a000-000000000040', product_id=40, quantity=1 |
| order | checkout | id=90, customer_id='dddddddd-0040-4000-a000-000000000040', email='rate_bao@test.com', shipping_address_id=240, billing_address_id=240, total_amount=2190000, payment_method='BANK_TRANSFER' |
| order | order | id=90, checkout_id=90, customer_id='dddddddd-0040-4000-a000-000000000040', total_amount=2190000, order_status='COMPLETED' |
| rating | rating | id=40, customer_id='dddddddd-0040-4000-a000-000000000040', product_id=40, rating_stars=5, headline='Bảng vẽ xịn', comment='Bảng vẽ nhạy, kết nối Bluetooth ổn định, driver cài dễ', created_by='dddddddd-0040-4000-a000-000000000040', order_id=90 |

Keycloak: `id=dddddddd-0040-4000-a000-000000000040, username=rate_bao, email=rate_bao@test.com, role=CUSTOMER`

---

### Scenario 41 — Ly Thi Cam rates Enfamil formula ★★★★★

Cam bought 3 Enfamil NeuroPro (product_id=41). 5 stars. "Sữa bé uống tốt, không bị táo bón, tăng cân đều".

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=241, user_id='dddddddd-0041-4000-a000-000000000041', phone='0921234541', address_line='6 Hàng Đào', city='Hà Nội', district_id=1, state_id=1, country_id=1, is_default=true |
| cart | cart_item | customer_id='dddddddd-0041-4000-a000-000000000041', product_id=41, quantity=3 |
| order | checkout | id=91, customer_id='dddddddd-0041-4000-a000-000000000041', email='rate_cam@test.com', shipping_address_id=241, billing_address_id=241, total_amount=2340000, payment_method='COD' |
| order | order | id=91, checkout_id=91, customer_id='dddddddd-0041-4000-a000-000000000041', total_amount=2340000, order_status='COMPLETED' |
| rating | rating | id=41, customer_id='dddddddd-0041-4000-a000-000000000041', product_id=41, rating_stars=5, headline='Sữa tốt cho bé', comment='Sữa bé uống tốt, không bị táo bón, tăng cân đều', created_by='dddddddd-0041-4000-a000-000000000041', order_id=91 |

Keycloak: `id=dddddddd-0041-4000-a000-000000000041, username=rate_cam, email=rate_cam@test.com, role=CUSTOMER`

---

### Scenario 42 — Nguyen Van Khanh rates Winmau dartboard ★★★★

Khanh bought Winmau Blade 6 (product_id=42). 4 stars. "Bảng phóng lao sisal bền, dây phân vùng mỏng, lắp tường dễ".

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=242, user_id='dddddddd-0042-4000-a000-000000000042', phone='0921234542', address_line='300 Đinh Tiên Hoàng', city='TP. Hồ Chí Minh', district_id=3, state_id=2, country_id=1, is_default=true |
| cart | cart_item | customer_id='dddddddd-0042-4000-a000-000000000042', product_id=42, quantity=1 |
| order | checkout | id=92, customer_id='dddddddd-0042-4000-a000-000000000042', email='rate_khanh2@test.com', shipping_address_id=242, billing_address_id=242, total_amount=1350000, payment_method='COD' |
| order | order | id=92, checkout_id=92, customer_id='dddddddd-0042-4000-a000-000000000042', total_amount=1350000, order_status='COMPLETED' |
| rating | rating | id=42, customer_id='dddddddd-0042-4000-a000-000000000042', product_id=42, rating_stars=4, headline='Dartboard tốt', comment='Bảng phóng lao sisal bền, dây phân vùng mỏng, lắp tường dễ', created_by='dddddddd-0042-4000-a000-000000000042', order_id=92 |

Keycloak: `id=dddddddd-0042-4000-a000-000000000042, username=rate_khanh2, email=rate_khanh2@test.com, role=CUSTOMER`

---

### Scenario 43 — Phan Thi My Hanh rates Sistema containers ★★★★★

Hanh bought 5 Sistema Brilliance 1.6L (product_id=43). 5 stars. "Hộp kín tuyệt đối, không mùi nhựa, xếp gọn trong tủ lạnh".

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=243, user_id='dddddddd-0043-4000-a000-000000000043', phone='0921234543', address_line='48 Hùng Vương', city='Đà Nẵng', district_id=5, state_id=3, country_id=1, is_default=true |
| cart | cart_item | customer_id='dddddddd-0043-4000-a000-000000000043', product_id=43, quantity=5 |
| order | checkout | id=93, customer_id='dddddddd-0043-4000-a000-000000000043', email='rate_hanh@test.com', shipping_address_id=243, billing_address_id=243, total_amount=925000, payment_method='COD' |
| order | order | id=93, checkout_id=93, customer_id='dddddddd-0043-4000-a000-000000000043', total_amount=925000, order_status='COMPLETED' |
| rating | rating | id=43, customer_id='dddddddd-0043-4000-a000-000000000043', product_id=43, rating_stars=5, headline='Hộp cực tốt', comment='Hộp kín tuyệt đối, không mùi nhựa, xếp gọn trong tủ lạnh', created_by='dddddddd-0043-4000-a000-000000000043', order_id=93 |

Keycloak: `id=dddddddd-0043-4000-a000-000000000043, username=rate_hanh, email=rate_hanh@test.com, role=CUSTOMER`

---

### Scenario 44 — Cao Minh Duc rates Sony earbuds ★★★★★

Duc bought Sony WF-1000XM5 (product_id=44). 5 stars. "Chống ồn tuyệt vời, âm thanh hi-fi, pin 8 giờ liên tục".

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=244, user_id='dddddddd-0044-4000-a000-000000000044', phone='0921234544', address_line='82 Lê Thánh Tông', city='Hải Phòng', district_id=7, state_id=4, country_id=1, is_default=true |
| cart | cart_item | customer_id='dddddddd-0044-4000-a000-000000000044', product_id=44, quantity=1 |
| order | checkout | id=94, customer_id='dddddddd-0044-4000-a000-000000000044', email='rate_duc2@test.com', shipping_address_id=244, billing_address_id=244, total_amount=6490000, payment_method='BANK_TRANSFER' |
| order | order | id=94, checkout_id=94, customer_id='dddddddd-0044-4000-a000-000000000044', total_amount=6490000, order_status='COMPLETED' |
| rating | rating | id=44, customer_id='dddddddd-0044-4000-a000-000000000044', product_id=44, rating_stars=5, headline='Tai nghe đỉnh', comment='Chống ồn tuyệt vời, âm thanh hi-fi, pin 8 giờ liên tục', created_by='dddddddd-0044-4000-a000-000000000044', order_id=94 |

Keycloak: `id=dddddddd-0044-4000-a000-000000000044, username=rate_duc2, email=rate_duc2@test.com, role=CUSTOMER`

---

### Scenario 45 — Nguyen Thi Nhu Quynh rates Hydro Flask ★★★★★

Quynh bought Hydro Flask 32oz Flamingo (product_id=45). 5 stars. "Bình giữ lạnh 24 giờ chuẩn, không gỉ sét, màu hồng đẹp".

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=245, user_id='dddddddd-0045-4000-a000-000000000045', phone='0921234545', address_line='31 Đường Cần Thơ', city='Cần Thơ', district_id=9, state_id=5, country_id=1, is_default=true |
| cart | cart_item | customer_id='dddddddd-0045-4000-a000-000000000045', product_id=45, quantity=1 |
| order | checkout | id=95, customer_id='dddddddd-0045-4000-a000-000000000045', email='rate_quynh2@test.com', shipping_address_id=245, billing_address_id=245, total_amount=1190000, payment_method='COD' |
| order | order | id=95, checkout_id=95, customer_id='dddddddd-0045-4000-a000-000000000045', total_amount=1190000, order_status='COMPLETED' |
| rating | rating | id=45, customer_id='dddddddd-0045-4000-a000-000000000045', product_id=45, rating_stars=5, headline='Bình nước tốt', comment='Bình giữ lạnh 24 giờ chuẩn, không gỉ sét, màu hồng đẹp', created_by='dddddddd-0045-4000-a000-000000000045', order_id=95 |

Keycloak: `id=dddddddd-0045-4000-a000-000000000045, username=rate_quynh2, email=rate_quynh2@test.com, role=CUSTOMER`

---

### Scenario 46 — Vo Ngoc Tuan rates Anker projector ★★★★

Tuan bought Anker Nebula Capsule II (product_id=46). 4 stars. "Máy chiếu nhỏ gọn, Android TV, chỉ thiếu độ sáng cao hơn".

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=246, user_id='dddddddd-0046-4000-a000-000000000046', phone='0921234546', address_line='58 Phan Bội Châu', city='Huế', district_id=11, state_id=6, country_id=1, is_default=true |
| cart | cart_item | customer_id='dddddddd-0046-4000-a000-000000000046', product_id=46, quantity=1 |
| order | checkout | id=96, customer_id='dddddddd-0046-4000-a000-000000000046', email='rate_tuan2@test.com', shipping_address_id=246, billing_address_id=246, total_amount=9990000, payment_method='BANK_TRANSFER' |
| order | order | id=96, checkout_id=96, customer_id='dddddddd-0046-4000-a000-000000000046', total_amount=9990000, order_status='COMPLETED' |
| rating | rating | id=46, customer_id='dddddddd-0046-4000-a000-000000000046', product_id=46, rating_stars=4, headline='Máy chiếu mini ổn', comment='Máy chiếu nhỏ gọn, Android TV, chỉ thiếu độ sáng cao hơn', created_by='dddddddd-0046-4000-a000-000000000046', order_id=96 |

Keycloak: `id=dddddddd-0046-4000-a000-000000000046, username=rate_tuan2, email=rate_tuan2@test.com, role=CUSTOMER`

---

### Scenario 47 — Bui Thi Thu Huong rates Oral-B toothbrush ★★★★★

Huong bought Oral-B iO Series 7 (product_id=47). 5 stars. "Bàn chải AI cảm biến áp lực, răng trắng hơn sau 2 tuần".

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=247, user_id='dddddddd-0047-4000-a000-000000000047', phone='0921234547', address_line='4 Bến Chợ', city='Nha Trang', district_id=13, state_id=7, country_id=1, is_default=true |
| cart | cart_item | customer_id='dddddddd-0047-4000-a000-000000000047', product_id=47, quantity=1 |
| order | checkout | id=97, customer_id='dddddddd-0047-4000-a000-000000000047', email='rate_huong@test.com', shipping_address_id=247, billing_address_id=247, total_amount=3990000, payment_method='BANK_TRANSFER' |
| order | order | id=97, checkout_id=97, customer_id='dddddddd-0047-4000-a000-000000000047', total_amount=3990000, order_status='COMPLETED' |
| rating | rating | id=47, customer_id='dddddddd-0047-4000-a000-000000000047', product_id=47, rating_stars=5, headline='Bàn chải xịn', comment='Bàn chải AI cảm biến áp lực, răng trắng hơn sau 2 tuần', created_by='dddddddd-0047-4000-a000-000000000047', order_id=97 |

Keycloak: `id=dddddddd-0047-4000-a000-000000000047, username=rate_huong, email=rate_huong@test.com, role=CUSTOMER`

---

### Scenario 48 — Le Thi Xuan Mai rates Vietnamese cookbook ★★★★★

Xuan Mai bought 2 Bếp Việt Miền Trung (product_id=48). 5 stars. "Sách ảnh đẹp, công thức chi tiết, nấu được ngay lần đầu".

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=248, user_id='dddddddd-0048-4000-a000-000000000048', phone='0921234548', address_line='66 Trần Quốc Toản', city='Đà Lạt', district_id=16, state_id=8, country_id=1, is_default=true |
| cart | cart_item | customer_id='dddddddd-0048-4000-a000-000000000048', product_id=48, quantity=2 |
| order | checkout | id=98, customer_id='dddddddd-0048-4000-a000-000000000048', email='rate_xmai@test.com', shipping_address_id=248, billing_address_id=248, total_amount=420000, payment_method='COD' |
| order | order | id=98, checkout_id=98, customer_id='dddddddd-0048-4000-a000-000000000048', total_amount=420000, order_status='COMPLETED' |
| rating | rating | id=48, customer_id='dddddddd-0048-4000-a000-000000000048', product_id=48, rating_stars=5, headline='Sách nấu ăn hay', comment='Sách ảnh đẹp, công thức chi tiết, nấu được ngay lần đầu', created_by='dddddddd-0048-4000-a000-000000000048', order_id=98 |

Keycloak: `id=dddddddd-0048-4000-a000-000000000048, username=rate_xmai, email=rate_xmai@test.com, role=CUSTOMER`

---

### Scenario 49 — Nguyen Thanh Phong rates Spigen car mount ★★★★

Phong bought Spigen GTS300 MagSafe (product_id=49). 4 stars. "Giá đỡ hút mạnh, xoay 360 độ, chỉ hỗ trợ MagSafe".

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=249, user_id='dddddddd-0049-4000-a000-000000000049', phone='0921234549', address_line='102 Hoàng Hoa Thám', city='Vũng Tàu', district_id=17, state_id=9, country_id=1, is_default=true |
| cart | cart_item | customer_id='dddddddd-0049-4000-a000-000000000049', product_id=49, quantity=1 |
| order | checkout | id=99, customer_id='dddddddd-0049-4000-a000-000000000049', email='rate_phong@test.com', shipping_address_id=249, billing_address_id=249, total_amount=590000, payment_method='COD' |
| order | order | id=99, checkout_id=99, customer_id='dddddddd-0049-4000-a000-000000000049', total_amount=590000, order_status='COMPLETED' |
| rating | rating | id=49, customer_id='dddddddd-0049-4000-a000-000000000049', product_id=49, rating_stars=4, headline='Giá đỡ ổn', comment='Giá đỡ hút mạnh, xoay 360 độ, chỉ hỗ trợ MagSafe', created_by='dddddddd-0049-4000-a000-000000000049', order_id=99 |

Keycloak: `id=dddddddd-0049-4000-a000-000000000049, username=rate_phong, email=rate_phong@test.com, role=CUSTOMER`

---

### Scenario 50 — Tran Thi My Linh rates Diptyque candle ★★★★★

Linh bought Diptyque Baies 190g (product_id=50). 5 stars. "Nến thơm hương hoa hồng thanh tao, cháy đều 40 giờ".

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| customer | user_address | id=250, user_id='dddddddd-0050-4000-a000-000000000050', phone='0921234550', address_line='39 Phạm Văn Thuận', city='Biên Hòa', district_id=20, state_id=10, country_id=1, is_default=true |
| cart | cart_item | customer_id='dddddddd-0050-4000-a000-000000000050', product_id=50, quantity=1 |
| order | checkout | id=100, customer_id='dddddddd-0050-4000-a000-000000000050', email='rate_linh@test.com', shipping_address_id=250, billing_address_id=250, total_amount=1850000, payment_method='COD' |
| order | order | id=100, checkout_id=100, customer_id='dddddddd-0050-4000-a000-000000000050', total_amount=1850000, order_status='COMPLETED' |
| rating | rating | id=50, customer_id='dddddddd-0050-4000-a000-000000000050', product_id=50, rating_stars=5, headline='Nến thơm tuyệt', comment='Nến thơm hương hoa hồng thanh tao, cháy đều 40 giờ', created_by='dddddddd-0050-4000-a000-000000000050', order_id=100 |

Keycloak: `id=dddddddd-0050-4000-a000-000000000050, username=rate_linh, email=rate_linh@test.com, role=CUSTOMER`

---

## Data State: admin_product_management

*Enables flows: product_create_admin_success, product_update_admin_success, product_delete_admin_success, customer_list_admin_success, order_list_admin_success, rating_list_admin_success, rating_delete_admin_success, inventory_list_stock_admin_success, promotion_create_admin_success, promotion_list_admin_success, tax_list_admin_success, tax_create_admin_success*

*Depends on: product_catalog group (products 1–50 for update/delete targets)*

*UUID pattern: `eeeeeeee-00NN-4000-a000-000000000NNN` (N=01..50)*

Each scenario seeds ONE ADMIN user. Admin user can call any backoffice endpoint. Product target for update/delete references existing product IDs 1–50.

---

### Scenario 1 — Admin nguyen_admin manages product 1 (ao dai)

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| *(no DB entity needed beyond Keycloak role)* | — | — |

Keycloak: `id=eeeeeeee-0001-4000-a000-000000000001, username=nguyen_admin, email=nguyen_admin@yas.local, role=ADMIN`
Target product for update/delete: product_id=1

---

### Scenario 2 — Admin tran_admin manages product 2 (Adidas shoes)

Keycloak: `id=eeeeeeee-0002-4000-a000-000000000002, username=tran_admin, email=tran_admin@yas.local, role=ADMIN`
Target product: product_id=2

---

### Scenario 3 — Admin le_admin manages product 3 (tea set)

Keycloak: `id=eeeeeeee-0003-4000-a000-000000000003, username=le_admin, email=le_admin@yas.local, role=ADMIN`
Target product: product_id=3

---

### Scenario 4 — Admin pham_admin manages product 4 (backpack)

Keycloak: `id=eeeeeeee-0004-4000-a000-000000000004, username=pham_admin, email=pham_admin@yas.local, role=ADMIN`
Target product: product_id=4

---

### Scenario 5 — Admin hoang_admin manages product 5 (coffee)

Keycloak: `id=eeeeeeee-0005-4000-a000-000000000005, username=hoang_admin, email=hoang_admin@yas.local, role=ADMIN`
Target product: product_id=5

---

### Scenario 6 — Admin vo_admin manages product 6 (Apple Watch)

Keycloak: `id=eeeeeeee-0006-4000-a000-000000000006, username=vo_admin, email=vo_admin@yas.local, role=ADMIN`
Target product: product_id=6

---

### Scenario 7 — Admin bui_admin manages product 7 (serum)

Keycloak: `id=eeeeeeee-0007-4000-a000-000000000007, username=bui_admin, email=bui_admin@yas.local, role=ADMIN`
Target product: product_id=7

---

### Scenario 8 — Admin do_admin manages product 8 (headset)

Keycloak: `id=eeeeeeee-0008-4000-a000-000000000008, username=do_admin, email=do_admin@yas.local, role=ADMIN`
Target product: product_id=8

---

### Scenario 9 — Admin vu_admin manages product 9 (matcha)

Keycloak: `id=eeeeeeee-0009-4000-a000-000000000009, username=vu_admin, email=vu_admin@yas.local, role=ADMIN`
Target product: product_id=9

---

### Scenario 10 — Admin dang_admin manages product 10 (yoga mat)

Keycloak: `id=eeeeeeee-0010-4000-a000-000000000010, username=dang_admin, email=dang_admin@yas.local, role=ADMIN`
Target product: product_id=10

---

### Scenario 11 — Admin ngo_admin manages product 11 (linen shirt)

Keycloak: `id=eeeeeeee-0011-4000-a000-000000000011, username=ngo_admin, email=ngo_admin@yas.local, role=ADMIN`
Target product: product_id=11

---

### Scenario 12 — Admin ly_admin manages product 12 (vacuum)

Keycloak: `id=eeeeeeee-0012-4000-a000-000000000012, username=ly_admin, email=ly_admin@yas.local, role=ADMIN`
Target product: product_id=12

---

### Scenario 13 — Admin mai_admin manages product 13 (Doraemon)

Keycloak: `id=eeeeeeee-0013-4000-a000-000000000013, username=mai_admin, email=mai_admin@yas.local, role=ADMIN`
Target product: product_id=13

---

### Scenario 14 — Admin cao_admin manages product 14 (desk lamp)

Keycloak: `id=eeeeeeee-0014-4000-a000-000000000014, username=cao_admin, email=cao_admin@yas.local, role=ADMIN`
Target product: product_id=14

---

### Scenario 15 — Admin dinh_admin manages product 15 (cutting board)

Keycloak: `id=eeeeeeee-0015-4000-a000-000000000015, username=dinh_admin, email=dinh_admin@yas.local, role=ADMIN`
Target product: product_id=15

---

### Scenario 16 — Admin trinh_admin manages product 16 (vitamins)

Keycloak: `id=eeeeeeee-0016-4000-a000-000000000016, username=trinh_admin, email=trinh_admin@yas.local, role=ADMIN`
Target product: product_id=16

---

### Scenario 17 — Admin dao_admin manages product 17 (keyboard)

Keycloak: `id=eeeeeeee-0017-4000-a000-000000000017, username=dao_admin, email=dao_admin@yas.local, role=ADMIN`
Target product: product_id=17

---

### Scenario 18 — Admin truong_admin manages product 18 (scarf)

Keycloak: `id=eeeeeeee-0018-4000-a000-000000000018, username=truong_admin, email=truong_admin@yas.local, role=ADMIN`
Target product: product_id=18

---

### Scenario 19 — Admin luong_admin manages product 19 (JBL speaker)

Keycloak: `id=eeeeeeee-0019-4000-a000-000000000019, username=luong_admin, email=luong_admin@yas.local, role=ADMIN`
Target product: product_id=19

---

### Scenario 20 — Admin phan_admin manages product 20 (succulent)

Keycloak: `id=eeeeeeee-0020-4000-a000-000000000020, username=phan_admin, email=phan_admin@yas.local, role=ADMIN`
Target product: product_id=20

---

### Scenario 21 — Admin ha_admin manages product 21 (rice cooker)

Keycloak: `id=eeeeeeee-0021-4000-a000-000000000021, username=ha_admin, email=ha_admin@yas.local, role=ADMIN`
Target product: product_id=21

---

### Scenario 22 — Admin tien_admin manages product 22 (fishing combo)

Keycloak: `id=eeeeeeee-0022-4000-a000-000000000022, username=tien_admin, email=tien_admin@yas.local, role=ADMIN`
Target product: product_id=22

---

### Scenario 23 — Admin hung_admin manages product 23 (COSRX toner)

Keycloak: `id=eeeeeeee-0023-4000-a000-000000000023, username=hung_admin, email=hung_admin@yas.local, role=ADMIN`
Target product: product_id=23

---

### Scenario 24 — Admin duc_admin manages product 24 (watch cable)

Keycloak: `id=eeeeeeee-0024-4000-a000-000000000024, username=duc_admin, email=duc_admin@yas.local, role=ADMIN`
Target product: product_id=24

---

### Scenario 25 — Admin hai_admin manages product 25 (frying pan)

Keycloak: `id=eeeeeeee-0025-4000-a000-000000000025, username=hai_admin, email=hai_admin@yas.local, role=ADMIN`
Target product: product_id=25

---

### Scenario 26 — Admin thanh_admin manages product 26 (Lacoste polo)

Keycloak: `id=eeeeeeee-0026-4000-a000-000000000026, username=thanh_admin, email=thanh_admin@yas.local, role=ADMIN`
Target product: product_id=26

---

### Scenario 27 — Admin khanh_admin manages product 27 (kids bike)

Keycloak: `id=eeeeeeee-0027-4000-a000-000000000027, username=khanh_admin, email=khanh_admin@yas.local, role=ADMIN`
Target product: product_id=27

---

### Scenario 28 — Admin son_admin manages product 28 (power bank)

Keycloak: `id=eeeeeeee-0028-4000-a000-000000000028, username=son_admin, email=son_admin@yas.local, role=ADMIN`
Target product: product_id=28

---

### Scenario 29 — Admin minh_admin manages product 29 (puzzle)

Keycloak: `id=eeeeeeee-0029-4000-a000-000000000029, username=minh_admin, email=minh_admin@yas.local, role=ADMIN`
Target product: product_id=29

---

### Scenario 30 — Admin long_admin manages product 30 (Chanel perfume)

Keycloak: `id=eeeeeeee-0030-4000-a000-000000000030, username=long_admin, email=long_admin@yas.local, role=ADMIN`
Target product: product_id=30

---

### Scenario 31 — Admin nam_admin manages product 31 (router)

Keycloak: `id=eeeeeeee-0031-4000-a000-000000000031, username=nam_admin, email=nam_admin@yas.local, role=ADMIN`
Target product: product_id=31

---

### Scenario 32 — Admin tuan_admin manages product 32 (essential oil)

Keycloak: `id=eeeeeeee-0032-4000-a000-000000000032, username=tuan_admin, email=tuan_admin@yas.local, role=ADMIN`
Target product: product_id=32

---

### Scenario 33 — Admin hieu_admin manages product 33 (whey protein)

Keycloak: `id=eeeeeeee-0033-4000-a000-000000000033, username=hieu_admin, email=hieu_admin@yas.local, role=ADMIN`
Target product: product_id=33

---

### Scenario 34 — Admin an_admin manages product 34 (planner)

Keycloak: `id=eeeeeeee-0034-4000-a000-000000000034, username=an_admin, email=an_admin@yas.local, role=ADMIN`
Target product: product_id=34

---

### Scenario 35 — Admin binh_admin manages product 35 (sunscreen)

Keycloak: `id=eeeeeeee-0035-4000-a000-000000000035, username=binh_admin, email=binh_admin@yas.local, role=ADMIN`
Target product: product_id=35

---

### Scenario 36 — Admin cuong_admin manages product 36 (phone case)

Keycloak: `id=eeeeeeee-0036-4000-a000-000000000036, username=cuong_admin, email=cuong_admin@yas.local, role=ADMIN`
Target product: product_id=36

---

### Scenario 37 — Admin hoa_admin manages product 37 (hair dryer)

Keycloak: `id=eeeeeeee-0037-4000-a000-000000000037, username=hoa_admin, email=hoa_admin@yas.local, role=ADMIN`
Target product: product_id=37

---

### Scenario 38 — Admin thu_admin manages product 38 (travel pillow)

Keycloak: `id=eeeeeeee-0038-4000-a000-000000000038, username=thu_admin, email=thu_admin@yas.local, role=ADMIN`
Target product: product_id=38

---

### Scenario 39 — Admin oanh_admin manages product 39 (waffle maker)

Keycloak: `id=eeeeeeee-0039-4000-a000-000000000039, username=oanh_admin, email=oanh_admin@yas.local, role=ADMIN`
Target product: product_id=39

---

### Scenario 40 — Admin kim_admin manages product 40 (drawing tablet)

Keycloak: `id=eeeeeeee-0040-4000-a000-000000000040, username=kim_admin, email=kim_admin@yas.local, role=ADMIN`
Target product: product_id=40

---

### Scenario 41 — Admin lan_admin manages product 41 (baby formula)

Keycloak: `id=eeeeeeee-0041-4000-a000-000000000041, username=lan_admin, email=lan_admin@yas.local, role=ADMIN`
Target product: product_id=41

---

### Scenario 42 — Admin bich_admin manages product 42 (dartboard)

Keycloak: `id=eeeeeeee-0042-4000-a000-000000000042, username=bich_admin, email=bich_admin@yas.local, role=ADMIN`
Target product: product_id=42

---

### Scenario 43 — Admin huyen_admin manages product 43 (food containers)

Keycloak: `id=eeeeeeee-0043-4000-a000-000000000043, username=huyen_admin, email=huyen_admin@yas.local, role=ADMIN`
Target product: product_id=43

---

### Scenario 44 — Admin thuy_admin manages product 44 (earbuds)

Keycloak: `id=eeeeeeee-0044-4000-a000-000000000044, username=thuy_admin, email=thuy_admin@yas.local, role=ADMIN`
Target product: product_id=44

---

### Scenario 45 — Admin nga_admin manages product 45 (water bottle)

Keycloak: `id=eeeeeeee-0045-4000-a000-000000000045, username=nga_admin, email=nga_admin@yas.local, role=ADMIN`
Target product: product_id=45

---

### Scenario 46 — Admin linh_admin manages product 46 (projector)

Keycloak: `id=eeeeeeee-0046-4000-a000-000000000046, username=linh_admin, email=linh_admin@yas.local, role=ADMIN`
Target product: product_id=46

---

### Scenario 47 — Admin thao_admin manages product 47 (electric toothbrush)

Keycloak: `id=eeeeeeee-0047-4000-a000-000000000047, username=thao_admin, email=thao_admin@yas.local, role=ADMIN`
Target product: product_id=47

---

### Scenario 48 — Admin phuong_admin manages product 48 (cookbook)

Keycloak: `id=eeeeeeee-0048-4000-a000-000000000048, username=phuong_admin, email=phuong_admin@yas.local, role=ADMIN`
Target product: product_id=48

---

### Scenario 49 — Admin ngoc_admin manages product 49 (car mount)

Keycloak: `id=eeeeeeee-0049-4000-a000-000000000049, username=ngoc_admin, email=ngoc_admin@yas.local, role=ADMIN`
Target product: product_id=49

---

### Scenario 50 — Admin hang_admin manages product 50 (scented candle)

Keycloak: `id=eeeeeeee-0050-4000-a000-000000000050, username=hang_admin, email=hang_admin@yas.local, role=ADMIN`
Target product: product_id=50

---

## Data State: active_promotion

*Enables flows: promotion_verify_success, promotion_create_admin_success, promotion_list_admin_success*

*Depends on: product_catalog group (products 1–50)*

Each scenario seeds 1 active promotion linked to a product. Promotions alternate between PERCENTAGE (% off) and FIXED (VND off). All active from 2026-01-01 to 2026-12-31.

| DB | Promotion fields |
|----|-----------------|
| promotion | id, code, discount_type, discount_value, product_id, start_date, end_date, is_active=true |

---

### Scenario 1 — 10% off ao dai (product_id=1)

| DB | Entity | Key values |
|----|--------|------------|
| promotion | promotion | id=1, code='AOAI10', discount_type='PERCENTAGE', discount_value=10, product_id=1, start_date='2026-01-01', end_date='2026-12-31', is_active=true |

---

### Scenario 2 — 200000 VND off Adidas shoes (product_id=2)

| DB | Entity | Key values |
|----|--------|------------|
| promotion | promotion | id=2, code='ADIDAS200K', discount_type='FIXED', discount_value=200000, product_id=2, start_date='2026-01-01', end_date='2026-12-31', is_active=true |

---

### Scenario 3 — 15% off tea set (product_id=3)

| DB | Entity | Key values |
|----|--------|------------|
| promotion | promotion | id=3, code='TEA15PCT', discount_type='PERCENTAGE', discount_value=15, product_id=3, start_date='2026-01-01', end_date='2026-12-31', is_active=true |

---

### Scenario 4 — 100000 VND off backpack (product_id=4)

| DB | Entity | Key values |
|----|--------|------------|
| promotion | promotion | id=4, code='BAG100K', discount_type='FIXED', discount_value=100000, product_id=4, start_date='2026-01-01', end_date='2026-12-31', is_active=true |

---

### Scenario 5 — 20% off coffee (product_id=5)

| DB | Entity | Key values |
|----|--------|------------|
| promotion | promotion | id=5, code='COFFEE20', discount_type='PERCENTAGE', discount_value=20, product_id=5, start_date='2026-01-01', end_date='2026-12-31', is_active=true |

---

### Scenario 6 — 500000 VND off Apple Watch (product_id=6)

| DB | Entity | Key values |
|----|--------|------------|
| promotion | promotion | id=6, code='WATCH500K', discount_type='FIXED', discount_value=500000, product_id=6, start_date='2026-01-01', end_date='2026-12-31', is_active=true |

---

### Scenario 7 — 10% off serum (product_id=7)

| DB | Entity | Key values |
|----|--------|------------|
| promotion | promotion | id=7, code='SERUM10', discount_type='PERCENTAGE', discount_value=10, product_id=7, start_date='2026-01-01', end_date='2026-12-31', is_active=true |

---

### Scenario 8 — 150000 VND off gaming headset (product_id=8)

| DB | Entity | Key values |
|----|--------|------------|
| promotion | promotion | id=8, code='GAMING150K', discount_type='FIXED', discount_value=150000, product_id=8, start_date='2026-01-01', end_date='2026-12-31', is_active=true |

---

### Scenario 9 — 5% off matcha (product_id=9)

| DB | Entity | Key values |
|----|--------|------------|
| promotion | promotion | id=9, code='MATCHA5', discount_type='PERCENTAGE', discount_value=5, product_id=9, start_date='2026-01-01', end_date='2026-12-31', is_active=true |

---

### Scenario 10 — 250000 VND off yoga mat (product_id=10)

| DB | Entity | Key values |
|----|--------|------------|
| promotion | promotion | id=10, code='YOGA250K', discount_type='FIXED', discount_value=250000, product_id=10, start_date='2026-01-01', end_date='2026-12-31', is_active=true |

---

### Scenario 11 — 12% off linen shirt (product_id=11)

| DB | Entity | Key values |
|----|--------|------------|
| promotion | promotion | id=11, code='LINEN12', discount_type='PERCENTAGE', discount_value=12, product_id=11, start_date='2026-01-01', end_date='2026-12-31', is_active=true |

---

### Scenario 12 — 1000000 VND off Dyson vacuum (product_id=12)

| DB | Entity | Key values |
|----|--------|------------|
| promotion | promotion | id=12, code='DYSON1M', discount_type='FIXED', discount_value=1000000, product_id=12, start_date='2026-01-01', end_date='2026-12-31', is_active=true |

---

### Scenario 13 — 25% off children's book (product_id=13)

| DB | Entity | Key values |
|----|--------|------------|
| promotion | promotion | id=13, code='BOOK25', discount_type='PERCENTAGE', discount_value=25, product_id=13, start_date='2026-01-01', end_date='2026-12-31', is_active=true |

---

### Scenario 14 — 50000 VND off desk lamp (product_id=14)

| DB | Entity | Key values |
|----|--------|------------|
| promotion | promotion | id=14, code='LAMP50K', discount_type='FIXED', discount_value=50000, product_id=14, start_date='2026-01-01', end_date='2026-12-31', is_active=true |

---

### Scenario 15 — 10% off cutting board set (product_id=15)

| DB | Entity | Key values |
|----|--------|------------|
| promotion | promotion | id=15, code='BOARD10', discount_type='PERCENTAGE', discount_value=10, product_id=15, start_date='2026-01-01', end_date='2026-12-31', is_active=true |

---

### Scenario 16 — 30000 VND off vitamins (product_id=16)

| DB | Entity | Key values |
|----|--------|------------|
| promotion | promotion | id=16, code='VIT30K', discount_type='FIXED', discount_value=30000, product_id=16, start_date='2026-01-01', end_date='2026-12-31', is_active=true |

---

### Scenario 17 — 8% off mechanical keyboard (product_id=17)

| DB | Entity | Key values |
|----|--------|------------|
| promotion | promotion | id=17, code='KB8PCT', discount_type='PERCENTAGE', discount_value=8, product_id=17, start_date='2026-01-01', end_date='2026-12-31', is_active=true |

---

### Scenario 18 — 100000 VND off silk scarf (product_id=18)

| DB | Entity | Key values |
|----|--------|------------|
| promotion | promotion | id=18, code='SILK100K', discount_type='FIXED', discount_value=100000, product_id=18, start_date='2026-01-01', end_date='2026-12-31', is_active=true |

---

### Scenario 19 — 15% off JBL speaker (product_id=19)

| DB | Entity | Key values |
|----|--------|------------|
| promotion | promotion | id=19, code='JBL15', discount_type='PERCENTAGE', discount_value=15, product_id=19, start_date='2026-01-01', end_date='2026-12-31', is_active=true |

---

### Scenario 20 — 10000 VND off succulent (product_id=20)

| DB | Entity | Key values |
|----|--------|------------|
| promotion | promotion | id=20, code='PLANT10K', discount_type='FIXED', discount_value=10000, product_id=20, start_date='2026-01-01', end_date='2026-12-31', is_active=true |

---

### Scenario 21 — 5% off rice cooker (product_id=21)

| DB | Entity | Key values |
|----|--------|------------|
| promotion | promotion | id=21, code='RICE5', discount_type='PERCENTAGE', discount_value=5, product_id=21, start_date='2026-01-01', end_date='2026-12-31', is_active=true |

---

### Scenario 22 — 80000 VND off fishing combo (product_id=22)

| DB | Entity | Key values |
|----|--------|------------|
| promotion | promotion | id=22, code='FISH80K', discount_type='FIXED', discount_value=80000, product_id=22, start_date='2026-01-01', end_date='2026-12-31', is_active=true |

---

### Scenario 23 — 20% off COSRX toner (product_id=23)

| DB | Entity | Key values |
|----|--------|------------|
| promotion | promotion | id=23, code='COSRX20', discount_type='PERCENTAGE', discount_value=20, product_id=23, start_date='2026-01-01', end_date='2026-12-31', is_active=true |

---

### Scenario 24 — 30000 VND off Garmin cable (product_id=24)

| DB | Entity | Key values |
|----|--------|------------|
| promotion | promotion | id=24, code='GAR30K', discount_type='FIXED', discount_value=30000, product_id=24, start_date='2026-01-01', end_date='2026-12-31', is_active=true |

---

### Scenario 25 — 10% off Tefal pan (product_id=25)

| DB | Entity | Key values |
|----|--------|------------|
| promotion | promotion | id=25, code='TEFAL10', discount_type='PERCENTAGE', discount_value=10, product_id=25, start_date='2026-01-01', end_date='2026-12-31', is_active=true |

---

### Scenario 26 — 200000 VND off Lacoste polo (product_id=26)

| DB | Entity | Key values |
|----|--------|------------|
| promotion | promotion | id=26, code='POLO200K', discount_type='FIXED', discount_value=200000, product_id=26, start_date='2026-01-01', end_date='2026-12-31', is_active=true |

---

### Scenario 27 — 8% off kids bike (product_id=27)

| DB | Entity | Key values |
|----|--------|------------|
| promotion | promotion | id=27, code='BIKE8', discount_type='PERCENTAGE', discount_value=8, product_id=27, start_date='2026-01-01', end_date='2026-12-31', is_active=true |

---

### Scenario 28 — 100000 VND off Anker power bank (product_id=28)

| DB | Entity | Key values |
|----|--------|------------|
| promotion | promotion | id=28, code='ANK100K', discount_type='FIXED', discount_value=100000, product_id=28, start_date='2026-01-01', end_date='2026-12-31', is_active=true |

---

### Scenario 29 — 15% off puzzle (product_id=29)

| DB | Entity | Key values |
|----|--------|------------|
| promotion | promotion | id=29, code='PUZZLE15', discount_type='PERCENTAGE', discount_value=15, product_id=29, start_date='2026-01-01', end_date='2026-12-31', is_active=true |

---

### Scenario 30 — 500000 VND off Chanel perfume (product_id=30)

| DB | Entity | Key values |
|----|--------|------------|
| promotion | promotion | id=30, code='CHANEL500K', discount_type='FIXED', discount_value=500000, product_id=30, start_date='2026-01-01', end_date='2026-12-31', is_active=true |

---

### Scenario 31 — 10% off WiFi router (product_id=31)

| DB | Entity | Key values |
|----|--------|------------|
| promotion | promotion | id=31, code='WIFI10', discount_type='PERCENTAGE', discount_value=10, product_id=31, start_date='2026-01-01', end_date='2026-12-31', is_active=true |

---

### Scenario 32 — 50000 VND off essential oil (product_id=32)

| DB | Entity | Key values |
|----|--------|------------|
| promotion | promotion | id=32, code='OIL50K', discount_type='FIXED', discount_value=50000, product_id=32, start_date='2026-01-01', end_date='2026-12-31', is_active=true |

---

### Scenario 33 — 10% off whey protein (product_id=33)

| DB | Entity | Key values |
|----|--------|------------|
| promotion | promotion | id=33, code='WHEY10', discount_type='PERCENTAGE', discount_value=10, product_id=33, start_date='2026-01-01', end_date='2026-12-31', is_active=true |

---

### Scenario 34 — 80000 VND off Hobonichi planner (product_id=34)

| DB | Entity | Key values |
|----|--------|------------|
| promotion | promotion | id=34, code='HOB80K', discount_type='FIXED', discount_value=80000, product_id=34, start_date='2026-01-01', end_date='2026-12-31', is_active=true |

---

### Scenario 35 — 12% off Anessa sunscreen (product_id=35)

| DB | Entity | Key values |
|----|--------|------------|
| promotion | promotion | id=35, code='SUN12', discount_type='PERCENTAGE', discount_value=12, product_id=35, start_date='2026-01-01', end_date='2026-12-31', is_active=true |

---

### Scenario 36 — 50000 VND off Spigen phone case (product_id=36)

| DB | Entity | Key values |
|----|--------|------------|
| promotion | promotion | id=36, code='CASE50K', discount_type='FIXED', discount_value=50000, product_id=36, start_date='2026-01-01', end_date='2026-12-31', is_active=true |

---

### Scenario 37 — 8% off Dyson hair dryer (product_id=37)

| DB | Entity | Key values |
|----|--------|------------|
| promotion | promotion | id=37, code='DRYER8', discount_type='PERCENTAGE', discount_value=8, product_id=37, start_date='2026-01-01', end_date='2026-12-31', is_active=true |

---

### Scenario 38 — 80000 VND off travel pillow (product_id=38)

| DB | Entity | Key values |
|----|--------|------------|
| promotion | promotion | id=38, code='TRAVEL80K', discount_type='FIXED', discount_value=80000, product_id=38, start_date='2026-01-01', end_date='2026-12-31', is_active=true |

---

### Scenario 39 — 10% off waffle maker (product_id=39)

| DB | Entity | Key values |
|----|--------|------------|
| promotion | promotion | id=39, code='WAFFLE10', discount_type='PERCENTAGE', discount_value=10, product_id=39, start_date='2026-01-01', end_date='2026-12-31', is_active=true |

---

### Scenario 40 — 200000 VND off Wacom tablet (product_id=40)

| DB | Entity | Key values |
|----|--------|------------|
| promotion | promotion | id=40, code='WACOM200K', discount_type='FIXED', discount_value=200000, product_id=40, start_date='2026-01-01', end_date='2026-12-31', is_active=true |

---

### Scenario 41 — 5% off baby formula (product_id=41)

| DB | Entity | Key values |
|----|--------|------------|
| promotion | promotion | id=41, code='MILK5', discount_type='PERCENTAGE', discount_value=5, product_id=41, start_date='2026-01-01', end_date='2026-12-31', is_active=true |

---

### Scenario 42 — 150000 VND off dartboard (product_id=42)

| DB | Entity | Key values |
|----|--------|------------|
| promotion | promotion | id=42, code='DART150K', discount_type='FIXED', discount_value=150000, product_id=42, start_date='2026-01-01', end_date='2026-12-31', is_active=true |

---

### Scenario 43 — 10% off food containers (product_id=43)

| DB | Entity | Key values |
|----|--------|------------|
| promotion | promotion | id=43, code='BOX10', discount_type='PERCENTAGE', discount_value=10, product_id=43, start_date='2026-01-01', end_date='2026-12-31', is_active=true |

---

### Scenario 44 — 500000 VND off Sony earbuds (product_id=44)

| DB | Entity | Key values |
|----|--------|------------|
| promotion | promotion | id=44, code='SONY500K', discount_type='FIXED', discount_value=500000, product_id=44, start_date='2026-01-01', end_date='2026-12-31', is_active=true |

---

### Scenario 45 — 10% off Hydro Flask (product_id=45)

| DB | Entity | Key values |
|----|--------|------------|
| promotion | promotion | id=45, code='HYDRO10', discount_type='PERCENTAGE', discount_value=10, product_id=45, start_date='2026-01-01', end_date='2026-12-31', is_active=true |

---

### Scenario 46 — 1000000 VND off Anker projector (product_id=46)

| DB | Entity | Key values |
|----|--------|------------|
| promotion | promotion | id=46, code='PROJ1M', discount_type='FIXED', discount_value=1000000, product_id=46, start_date='2026-01-01', end_date='2026-12-31', is_active=true |

---

### Scenario 47 — 15% off Oral-B toothbrush (product_id=47)

| DB | Entity | Key values |
|----|--------|------------|
| promotion | promotion | id=47, code='BRUSH15', discount_type='PERCENTAGE', discount_value=15, product_id=47, start_date='2026-01-01', end_date='2026-12-31', is_active=true |

---

### Scenario 48 — 30000 VND off cookbook (product_id=48)

| DB | Entity | Key values |
|----|--------|------------|
| promotion | promotion | id=48, code='COOK30K', discount_type='FIXED', discount_value=30000, product_id=48, start_date='2026-01-01', end_date='2026-12-31', is_active=true |

---

### Scenario 49 — 10% off Spigen car mount (product_id=49)

| DB | Entity | Key values |
|----|--------|------------|
| promotion | promotion | id=49, code='MOUNT10', discount_type='PERCENTAGE', discount_value=10, product_id=49, start_date='2026-01-01', end_date='2026-12-31', is_active=true |

---

### Scenario 50 — 200000 VND off Diptyque candle (product_id=50)

| DB | Entity | Key values |
|----|--------|------------|
| promotion | promotion | id=50, code='CANDLE200K', discount_type='FIXED', discount_value=200000, product_id=50, start_date='2026-01-01', end_date='2026-12-31', is_active=true |

---

## Data State: inventory_setup

*Enables flows: inventory_list_stock_admin_success, inventory_create_warehouse_admin_success*

*Depends on: product_catalog group (products 1–50)*

10 warehouses; each scenario seeds 1 warehouse + 5 stock entries (products rotating). warehouse ids: 1..10; stock ids: 1..50.

| Warehouse | ID | Location |
|-----------|----|---------:|
| Kho Hà Nội Trung Tâm | 1 | Hoàn Kiếm, Hà Nội |
| Kho TP.HCM Quận 1 | 2 | Quận 1, TP.HCM |
| Kho Đà Nẵng | 3 | Hải Châu, Đà Nẵng |
| Kho Hải Phòng | 4 | Lê Chân, Hải Phòng |
| Kho Cần Thơ | 5 | Ninh Kiều, Cần Thơ |
| Kho Huế | 6 | Phú Hội, Huế |
| Kho Nha Trang | 7 | Lộc Thọ, Nha Trang |
| Kho Đà Lạt | 8 | Phường 1, Đà Lạt |
| Kho Vũng Tàu | 9 | Phường 1, Vũng Tàu |
| Kho Biên Hòa | 10 | Tân Phong, Biên Hòa |

---

### Scenario 1 — Hanoi warehouse stocks ao dai (product 1)

| DB | Entity | Key values |
|----|--------|------------|
| inventory | warehouse | id=1, name='Kho Hà Nội Trung Tâm', address='12 Hàng Bài, Hoàn Kiếm, Hà Nội' |
| inventory | stock | id=1, product_id=1, warehouse_id=1, quantity=100 |

---

### Scenario 2 — Hanoi warehouse stocks Adidas shoes (product 2)

| DB | Entity | Key values |
|----|--------|------------|
| inventory | warehouse | id=1 (reuse) | 
| inventory | stock | id=2, product_id=2, warehouse_id=1, quantity=50 |

---

### Scenario 3 — Hanoi warehouse stocks tea set (product 3)

| DB | Entity | Key values |
|----|--------|------------|
| inventory | stock | id=3, product_id=3, warehouse_id=1, quantity=75 |

---

### Scenario 4 — Hanoi warehouse stocks backpack (product 4)

| DB | Entity | Key values |
|----|--------|------------|
| inventory | stock | id=4, product_id=4, warehouse_id=1, quantity=30 |

---

### Scenario 5 — Hanoi warehouse stocks coffee (product 5)

| DB | Entity | Key values |
|----|--------|------------|
| inventory | stock | id=5, product_id=5, warehouse_id=1, quantity=200 |

---

### Scenario 6 — HCMC warehouse stocks Apple Watch (product 6)

| DB | Entity | Key values |
|----|--------|------------|
| inventory | warehouse | id=2, name='Kho TP.HCM Quận 1', address='45 Nguyễn Huệ, Quận 1, TP.HCM' |
| inventory | stock | id=6, product_id=6, warehouse_id=2, quantity=20 |

---

### Scenario 7 — HCMC warehouse stocks serum (product 7)

| DB | Entity | Key values |
|----|--------|------------|
| inventory | stock | id=7, product_id=7, warehouse_id=2, quantity=150 |

---

### Scenario 8 — HCMC warehouse stocks gaming headset (product 8)

| DB | Entity | Key values |
|----|--------|------------|
| inventory | stock | id=8, product_id=8, warehouse_id=2, quantity=40 |

---

### Scenario 9 — HCMC warehouse stocks matcha (product 9)

| DB | Entity | Key values |
|----|--------|------------|
| inventory | stock | id=9, product_id=9, warehouse_id=2, quantity=80 |

---

### Scenario 10 — HCMC warehouse stocks yoga mat (product 10)

| DB | Entity | Key values |
|----|--------|------------|
| inventory | stock | id=10, product_id=10, warehouse_id=2, quantity=25 |

---

### Scenario 11 — Da Nang warehouse stocks linen shirt (product 11)

| DB | Entity | Key values |
|----|--------|------------|
| inventory | warehouse | id=3, name='Kho Đà Nẵng', address='78 Bạch Đằng, Hải Châu, Đà Nẵng' |
| inventory | stock | id=11, product_id=11, warehouse_id=3, quantity=60 |

---

### Scenario 12 — Da Nang warehouse stocks Dyson vacuum (product 12)

| DB | Entity | Key values |
|----|--------|------------|
| inventory | stock | id=12, product_id=12, warehouse_id=3, quantity=10 |

---

### Scenario 13 — Da Nang warehouse stocks Doraemon book (product 13)

| DB | Entity | Key values |
|----|--------|------------|
| inventory | stock | id=13, product_id=13, warehouse_id=3, quantity=300 |

---

### Scenario 14 — Da Nang warehouse stocks desk lamp (product 14)

| DB | Entity | Key values |
|----|--------|------------|
| inventory | stock | id=14, product_id=14, warehouse_id=3, quantity=45 |

---

### Scenario 15 — Da Nang warehouse stocks cutting board (product 15)

| DB | Entity | Key values |
|----|--------|------------|
| inventory | stock | id=15, product_id=15, warehouse_id=3, quantity=35 |

---

### Scenario 16 — Hai Phong warehouse stocks vitamins (product 16)

| DB | Entity | Key values |
|----|--------|------------|
| inventory | warehouse | id=4, name='Kho Hải Phòng', address='23 Điện Biên Phủ, Lê Chân, Hải Phòng' |
| inventory | stock | id=16, product_id=16, warehouse_id=4, quantity=120 |

---

### Scenario 17 — Hai Phong warehouse stocks keyboard (product 17)

| DB | Entity | Key values |
|----|--------|------------|
| inventory | stock | id=17, product_id=17, warehouse_id=4, quantity=30 |

---

### Scenario 18 — Hai Phong warehouse stocks silk scarf (product 18)

| DB | Entity | Key values |
|----|--------|------------|
| inventory | stock | id=18, product_id=18, warehouse_id=4, quantity=20 |

---

### Scenario 19 — Hai Phong warehouse stocks JBL speaker (product 19)

| DB | Entity | Key values |
|----|--------|------------|
| inventory | stock | id=19, product_id=19, warehouse_id=4, quantity=25 |

---

### Scenario 20 — Hai Phong warehouse stocks succulent (product 20)

| DB | Entity | Key values |
|----|--------|------------|
| inventory | stock | id=20, product_id=20, warehouse_id=4, quantity=90 |

---

### Scenario 21 — Can Tho warehouse stocks rice cooker (product 21)

| DB | Entity | Key values |
|----|--------|------------|
| inventory | warehouse | id=5, name='Kho Cần Thơ', address='56 Đường 3/2, Ninh Kiều, Cần Thơ' |
| inventory | stock | id=21, product_id=21, warehouse_id=5, quantity=15 |

---

### Scenario 22 — Can Tho warehouse stocks fishing combo (product 22)

| DB | Entity | Key values |
|----|--------|------------|
| inventory | stock | id=22, product_id=22, warehouse_id=5, quantity=40 |

---

### Scenario 23 — Can Tho warehouse stocks COSRX toner (product 23)

| DB | Entity | Key values |
|----|--------|------------|
| inventory | stock | id=23, product_id=23, warehouse_id=5, quantity=100 |

---

### Scenario 24 — Can Tho warehouse stocks Garmin cable (product 24)

| DB | Entity | Key values |
|----|--------|------------|
| inventory | stock | id=24, product_id=24, warehouse_id=5, quantity=60 |

---

### Scenario 25 — Can Tho warehouse stocks frying pan (product 25)

| DB | Entity | Key values |
|----|--------|------------|
| inventory | stock | id=25, product_id=25, warehouse_id=5, quantity=50 |

---

### Scenario 26 — Hue warehouse stocks Lacoste polo (product 26)

| DB | Entity | Key values |
|----|--------|------------|
| inventory | warehouse | id=6, name='Kho Huế', address='34 Lê Lợi, Phú Hội, Huế' |
| inventory | stock | id=26, product_id=26, warehouse_id=6, quantity=35 |

---

### Scenario 27 — Hue warehouse stocks kids bike (product 27)

| DB | Entity | Key values |
|----|--------|------------|
| inventory | stock | id=27, product_id=27, warehouse_id=6, quantity=12 |

---

### Scenario 28 — Hue warehouse stocks power bank (product 28)

| DB | Entity | Key values |
|----|--------|------------|
| inventory | stock | id=28, product_id=28, warehouse_id=6, quantity=80 |

---

### Scenario 29 — Hue warehouse stocks puzzle (product 29)

| DB | Entity | Key values |
|----|--------|------------|
| inventory | stock | id=29, product_id=29, warehouse_id=6, quantity=55 |

---

### Scenario 30 — Hue warehouse stocks Chanel perfume (product 30)

| DB | Entity | Key values |
|----|--------|------------|
| inventory | stock | id=30, product_id=30, warehouse_id=6, quantity=8 |

---

### Scenario 31 — Nha Trang warehouse stocks router (product 31)

| DB | Entity | Key values |
|----|--------|------------|
| inventory | warehouse | id=7, name='Kho Nha Trang', address='90 Trần Phú, Lộc Thọ, Nha Trang' |
| inventory | stock | id=31, product_id=31, warehouse_id=7, quantity=20 |

---

### Scenario 32 — Nha Trang warehouse stocks essential oil (product 32)

| DB | Entity | Key values |
|----|--------|------------|
| inventory | stock | id=32, product_id=32, warehouse_id=7, quantity=100 |

---

### Scenario 33 — Nha Trang warehouse stocks whey protein (product 33)

| DB | Entity | Key values |
|----|--------|------------|
| inventory | stock | id=33, product_id=33, warehouse_id=7, quantity=40 |

---

### Scenario 34 — Nha Trang warehouse stocks Hobonichi (product 34)

| DB | Entity | Key values |
|----|--------|------------|
| inventory | stock | id=34, product_id=34, warehouse_id=7, quantity=25 |

---

### Scenario 35 — Nha Trang warehouse stocks sunscreen (product 35)

| DB | Entity | Key values |
|----|--------|------------|
| inventory | stock | id=35, product_id=35, warehouse_id=7, quantity=150 |

---

### Scenario 36 — Da Lat warehouse stocks phone case (product 36)

| DB | Entity | Key values |
|----|--------|------------|
| inventory | warehouse | id=8, name='Kho Đà Lạt', address='15 Trần Hưng Đạo, Phường 1, Đà Lạt' |
| inventory | stock | id=36, product_id=36, warehouse_id=8, quantity=70 |

---

### Scenario 37 — Da Lat warehouse stocks Dyson hair dryer (product 37)

| DB | Entity | Key values |
|----|--------|------------|
| inventory | stock | id=37, product_id=37, warehouse_id=8, quantity=5 |

---

### Scenario 38 — Da Lat warehouse stocks travel pillow (product 38)

| DB | Entity | Key values |
|----|--------|------------|
| inventory | stock | id=38, product_id=38, warehouse_id=8, quantity=30 |

---

### Scenario 39 — Da Lat warehouse stocks waffle maker (product 39)

| DB | Entity | Key values |
|----|--------|------------|
| inventory | stock | id=39, product_id=39, warehouse_id=8, quantity=18 |

---

### Scenario 40 — Da Lat warehouse stocks Wacom tablet (product 40)

| DB | Entity | Key values |
|----|--------|------------|
| inventory | stock | id=40, product_id=40, warehouse_id=8, quantity=22 |

---

### Scenario 41 — Vung Tau warehouse stocks baby formula (product 41)

| DB | Entity | Key values |
|----|--------|------------|
| inventory | warehouse | id=9, name='Kho Vũng Tàu', address='67 Thùy Vân, Phường 1, Vũng Tàu' |
| inventory | stock | id=41, product_id=41, warehouse_id=9, quantity=60 |

---

### Scenario 42 — Vung Tau warehouse stocks dartboard (product 42)

| DB | Entity | Key values |
|----|--------|------------|
| inventory | stock | id=42, product_id=42, warehouse_id=9, quantity=15 |

---

### Scenario 43 — Vung Tau warehouse stocks food containers (product 43)

| DB | Entity | Key values |
|----|--------|------------|
| inventory | stock | id=43, product_id=43, warehouse_id=9, quantity=200 |

---

### Scenario 44 — Vung Tau warehouse stocks Sony earbuds (product 44)

| DB | Entity | Key values |
|----|--------|------------|
| inventory | stock | id=44, product_id=44, warehouse_id=9, quantity=10 |

---

### Scenario 45 — Vung Tau warehouse stocks Hydro Flask (product 45)

| DB | Entity | Key values |
|----|--------|------------|
| inventory | stock | id=45, product_id=45, warehouse_id=9, quantity=40 |

---

### Scenario 46 — Bien Hoa warehouse stocks Anker projector (product 46)

| DB | Entity | Key values |
|----|--------|------------|
| inventory | warehouse | id=10, name='Kho Biên Hòa', address='88 Đồng Khởi, Tân Phong, Biên Hòa' |
| inventory | stock | id=46, product_id=46, warehouse_id=10, quantity=8 |

---

### Scenario 47 — Bien Hoa warehouse stocks Oral-B toothbrush (product 47)

| DB | Entity | Key values |
|----|--------|------------|
| inventory | stock | id=47, product_id=47, warehouse_id=10, quantity=30 |

---

### Scenario 48 — Bien Hoa warehouse stocks cookbook (product 48)

| DB | Entity | Key values |
|----|--------|------------|
| inventory | stock | id=48, product_id=48, warehouse_id=10, quantity=120 |

---

### Scenario 49 — Bien Hoa warehouse stocks Spigen car mount (product 49)

| DB | Entity | Key values |
|----|--------|------------|
| inventory | stock | id=49, product_id=49, warehouse_id=10, quantity=50 |

---

### Scenario 50 — Bien Hoa warehouse stocks Diptyque candle (product 50)

| DB | Entity | Key values |
|----|--------|------------|
| inventory | stock | id=50, product_id=50, warehouse_id=10, quantity=12 |

---

## Data State: tax_setup

*Enables flows: tax_list_admin_success, tax_create_admin_success*

*Depends on: location seed (country 1, provinces 1–10)*

3 tax classes; 50 scenarios = tax_rate per province/class combination. tax_class ids: 1..3; tax_rate ids: 1..50.

Shared tax classes (insert once):
- `tax.tax_class` id=1, name='Standard Rate' (10%)
- `tax.tax_class` id=2, name='Reduced Rate' (5%)
- `tax.tax_class` id=3, name='Zero Rate' (0%)

---

### Scenario 1 — Standard 10% rate for Hà Nội (province 1)

| DB | Entity | Key values |
|----|--------|------------|
| tax | tax_class | id=1, name='Standard Rate' |
| tax | tax_rate | id=1, tax_class_id=1, zipcode='10000', rate=10 |

---

### Scenario 2 — Reduced 5% rate for Hà Nội

| DB | Entity | Key values |
|----|--------|------------|
| tax | tax_class | id=2, name='Reduced Rate' |
| tax | tax_rate | id=2, tax_class_id=2, zipcode='10000', rate=5 |

---

### Scenario 3 — Zero 0% rate for Hà Nội

| DB | Entity | Key values |
|----|--------|------------|
| tax | tax_class | id=3, name='Zero Rate' |
| tax | tax_rate | id=3, tax_class_id=3, zipcode='10000', rate=0 |

---

### Scenario 4 — Standard 10% rate for TP.HCM (province 2)

| DB | Entity | Key values |
|----|--------|------------|
| tax | tax_rate | id=4, tax_class_id=1, zipcode='70000', rate=10 |

---

### Scenario 5 — Reduced 5% rate for TP.HCM

| DB | Entity | Key values |
|----|--------|------------|
| tax | tax_rate | id=5, tax_class_id=2, zipcode='70000', rate=5 |

---

### Scenario 6 — Zero 0% rate for TP.HCM

| DB | Entity | Key values |
|----|--------|------------|
| tax | tax_rate | id=6, tax_class_id=3, zipcode='70000', rate=0 |

---

### Scenario 7 — Standard 10% rate for Đà Nẵng (province 3)

| DB | Entity | Key values |
|----|--------|------------|
| tax | tax_rate | id=7, tax_class_id=1, zipcode='55000', rate=10 |

---

### Scenario 8 — Reduced 5% rate for Đà Nẵng

| DB | Entity | Key values |
|----|--------|------------|
| tax | tax_rate | id=8, tax_class_id=2, zipcode='55000', rate=5 |

---

### Scenario 9 — Zero 0% rate for Đà Nẵng

| DB | Entity | Key values |
|----|--------|------------|
| tax | tax_rate | id=9, tax_class_id=3, zipcode='55000', rate=0 |

---

### Scenario 10 — Standard 10% rate for Hải Phòng (province 4)

| DB | Entity | Key values |
|----|--------|------------|
| tax | tax_rate | id=10, tax_class_id=1, zipcode='18000', rate=10 |

---

### Scenario 11 — Reduced 5% rate for Hải Phòng

| DB | Entity | Key values |
|----|--------|------------|
| tax | tax_rate | id=11, tax_class_id=2, zipcode='18000', rate=5 |

---

### Scenario 12 — Zero 0% rate for Hải Phòng

| DB | Entity | Key values |
|----|--------|------------|
| tax | tax_rate | id=12, tax_class_id=3, zipcode='18000', rate=0 |

---

### Scenario 13 — Standard 10% rate for Cần Thơ (province 5)

| DB | Entity | Key values |
|----|--------|------------|
| tax | tax_rate | id=13, tax_class_id=1, zipcode='94000', rate=10 |

---

### Scenario 14 — Reduced 5% rate for Cần Thơ

| DB | Entity | Key values |
|----|--------|------------|
| tax | tax_rate | id=14, tax_class_id=2, zipcode='94000', rate=5 |

---

### Scenario 15 — Zero 0% rate for Cần Thơ

| DB | Entity | Key values |
|----|--------|------------|
| tax | tax_rate | id=15, tax_class_id=3, zipcode='94000', rate=0 |

---

### Scenario 16 — Standard 10% rate for Huế (province 6)

| DB | Entity | Key values |
|----|--------|------------|
| tax | tax_rate | id=16, tax_class_id=1, zipcode='49000', rate=10 |

---

### Scenario 17 — Reduced 5% rate for Huế

| DB | Entity | Key values |
|----|--------|------------|
| tax | tax_rate | id=17, tax_class_id=2, zipcode='49000', rate=5 |

---

### Scenario 18 — Zero 0% rate for Huế

| DB | Entity | Key values |
|----|--------|------------|
| tax | tax_rate | id=18, tax_class_id=3, zipcode='49000', rate=0 |

---

### Scenario 19 — Standard 10% rate for Nha Trang (province 7)

| DB | Entity | Key values |
|----|--------|------------|
| tax | tax_rate | id=19, tax_class_id=1, zipcode='65000', rate=10 |

---

### Scenario 20 — Reduced 5% rate for Nha Trang

| DB | Entity | Key values |
|----|--------|------------|
| tax | tax_rate | id=20, tax_class_id=2, zipcode='65000', rate=5 |

---

### Scenario 21 — Zero 0% rate for Nha Trang

| DB | Entity | Key values |
|----|--------|------------|
| tax | tax_rate | id=21, tax_class_id=3, zipcode='65000', rate=0 |

---

### Scenario 22 — Standard 10% rate for Đà Lạt (province 8)

| DB | Entity | Key values |
|----|--------|------------|
| tax | tax_rate | id=22, tax_class_id=1, zipcode='67000', rate=10 |

---

### Scenario 23 — Reduced 5% rate for Đà Lạt

| DB | Entity | Key values |
|----|--------|------------|
| tax | tax_rate | id=23, tax_class_id=2, zipcode='67000', rate=5 |

---

### Scenario 24 — Zero 0% rate for Đà Lạt

| DB | Entity | Key values |
|----|--------|------------|
| tax | tax_rate | id=24, tax_class_id=3, zipcode='67000', rate=0 |

---

### Scenario 25 — Standard 10% rate for Vũng Tàu (province 9)

| DB | Entity | Key values |
|----|--------|------------|
| tax | tax_rate | id=25, tax_class_id=1, zipcode='79000', rate=10 |

---

### Scenario 26 — Reduced 5% rate for Vũng Tàu

| DB | Entity | Key values |
|----|--------|------------|
| tax | tax_rate | id=26, tax_class_id=2, zipcode='79000', rate=5 |

---

### Scenario 27 — Zero 0% rate for Vũng Tàu

| DB | Entity | Key values |
|----|--------|------------|
| tax | tax_rate | id=27, tax_class_id=3, zipcode='79000', rate=0 |

---

### Scenario 28 — Standard 10% rate for Biên Hòa (province 10)

| DB | Entity | Key values |
|----|--------|------------|
| tax | tax_rate | id=28, tax_class_id=1, zipcode='76000', rate=10 |

---

### Scenario 29 — Reduced 5% rate for Biên Hòa

| DB | Entity | Key values |
|----|--------|------------|
| tax | tax_rate | id=29, tax_class_id=2, zipcode='76000', rate=5 |

---

### Scenario 30 — Zero 0% rate for Biên Hòa

| DB | Entity | Key values |
|----|--------|------------|
| tax | tax_rate | id=30, tax_class_id=3, zipcode='76000', rate=0 |

---

### Scenario 31 — Luxury 15% rate for Hà Nội

Extra luxury rate class for high-value goods.

| DB | Entity | Key values |
|----|--------|------------|
| tax | tax_class | id=4, name='Luxury Rate' (one-time insert) |
| tax | tax_rate | id=31, tax_class_id=4, zipcode='10000', rate=15 |

---

### Scenario 32 — Luxury 15% rate for TP.HCM

| DB | Entity | Key values |
|----|--------|------------|
| tax | tax_rate | id=32, tax_class_id=4, zipcode='70000', rate=15 |

---

### Scenario 33 — Luxury 15% rate for Đà Nẵng

| DB | Entity | Key values |
|----|--------|------------|
| tax | tax_rate | id=33, tax_class_id=4, zipcode='55000', rate=15 |

---

### Scenario 34 — Luxury 15% rate for Hải Phòng

| DB | Entity | Key values |
|----|--------|------------|
| tax | tax_rate | id=34, tax_class_id=4, zipcode='18000', rate=15 |

---

### Scenario 35 — Luxury 15% rate for Cần Thơ

| DB | Entity | Key values |
|----|--------|------------|
| tax | tax_rate | id=35, tax_class_id=4, zipcode='94000', rate=15 |

---

### Scenario 36 — Luxury 15% rate for Huế

| DB | Entity | Key values |
|----|--------|------------|
| tax | tax_rate | id=36, tax_class_id=4, zipcode='49000', rate=15 |

---

### Scenario 37 — Luxury 15% rate for Nha Trang

| DB | Entity | Key values |
|----|--------|------------|
| tax | tax_rate | id=37, tax_class_id=4, zipcode='65000', rate=15 |

---

### Scenario 38 — Luxury 15% rate for Đà Lạt

| DB | Entity | Key values |
|----|--------|------------|
| tax | tax_rate | id=38, tax_class_id=4, zipcode='67000', rate=15 |

---

### Scenario 39 — Luxury 15% rate for Vũng Tàu

| DB | Entity | Key values |
|----|--------|------------|
| tax | tax_rate | id=39, tax_class_id=4, zipcode='79000', rate=15 |

---

### Scenario 40 — Luxury 15% rate for Biên Hòa

| DB | Entity | Key values |
|----|--------|------------|
| tax | tax_rate | id=40, tax_class_id=4, zipcode='76000', rate=15 |

---

### Scenario 41 — Digital services 8% rate for Hà Nội

VAT on digital/software services.

| DB | Entity | Key values |
|----|--------|------------|
| tax | tax_class | id=5, name='Digital Services Rate' (one-time insert) |
| tax | tax_rate | id=41, tax_class_id=5, zipcode='10000', rate=8 |

---

### Scenario 42 — Digital services 8% rate for TP.HCM

| DB | Entity | Key values |
|----|--------|------------|
| tax | tax_rate | id=42, tax_class_id=5, zipcode='70000', rate=8 |

---

### Scenario 43 — Digital services 8% rate for Đà Nẵng

| DB | Entity | Key values |
|----|--------|------------|
| tax | tax_rate | id=43, tax_class_id=5, zipcode='55000', rate=8 |

---

### Scenario 44 — Digital services 8% rate for Hải Phòng

| DB | Entity | Key values |
|----|--------|------------|
| tax | tax_rate | id=44, tax_class_id=5, zipcode='18000', rate=8 |

---

### Scenario 45 — Digital services 8% rate for Cần Thơ

| DB | Entity | Key values |
|----|--------|------------|
| tax | tax_rate | id=45, tax_class_id=5, zipcode='94000', rate=8 |

---

### Scenario 46 — Digital services 8% rate for Huế

| DB | Entity | Key values |
|----|--------|------------|
| tax | tax_rate | id=46, tax_class_id=5, zipcode='49000', rate=8 |

---

### Scenario 47 — Digital services 8% rate for Nha Trang

| DB | Entity | Key values |
|----|--------|------------|
| tax | tax_rate | id=47, tax_class_id=5, zipcode='65000', rate=8 |

---

### Scenario 48 — Digital services 8% rate for Đà Lạt

| DB | Entity | Key values |
|----|--------|------------|
| tax | tax_rate | id=48, tax_class_id=5, zipcode='67000', rate=8 |

---

### Scenario 49 — Digital services 8% rate for Vũng Tàu

| DB | Entity | Key values |
|----|--------|------------|
| tax | tax_rate | id=49, tax_class_id=5, zipcode='79000', rate=8 |

---

### Scenario 50 — Digital services 8% rate for Biên Hòa

| DB | Entity | Key values |
|----|--------|------------|
| tax | tax_rate | id=50, tax_class_id=5, zipcode='76000', rate=8 |

---

## Data State: payment_provider_setup

*Enables flows: payment_init_success*

50 payment provider configurations using 5 providers (MoMo, VNPay, Stripe, ZaloPay, PayPal) × 10 config variants each. payment_provider ids: 1..50.

| Provider | Type | Currency |
|----------|------|----------|
| MoMo | E-wallet | VND |
| VNPay | QR/ATM | VND |
| Stripe | Card | USD/VND |
| ZaloPay | E-wallet | VND |
| PayPal | International | USD |

---

### Scenario 1 — MoMo Sandbox config #1

| DB | Entity | Key values |
|----|--------|------------|
| payment | payment_provider | id=1, name='MoMo', additional_settings='{"partnerCode":"MOMO01","accessKey":"key01","secretKey":"secret01","endpoint":"https://test-payment.momo.vn/v2/gateway/api","returnUrl":"http://api.yas.local/payment/callback","environment":"SANDBOX"}' |

---

### Scenario 2 — MoMo Sandbox config #2

| DB | Entity | Key values |
|----|--------|------------|
| payment | payment_provider | id=2, name='MoMo', additional_settings='{"partnerCode":"MOMO02","accessKey":"key02","secretKey":"secret02","endpoint":"https://test-payment.momo.vn/v2/gateway/api","returnUrl":"http://api.yas.local/payment/callback","environment":"SANDBOX"}' |

---

### Scenario 3 — MoMo Sandbox config #3

| DB | Entity | Key values |
|----|--------|------------|
| payment | payment_provider | id=3, name='MoMo', additional_settings='{"partnerCode":"MOMO03","accessKey":"key03","secretKey":"secret03","endpoint":"https://test-payment.momo.vn/v2/gateway/api","returnUrl":"http://api.yas.local/payment/callback","environment":"SANDBOX"}' |

---

### Scenario 4 — MoMo Sandbox config #4

| DB | Entity | Key values |
|----|--------|------------|
| payment | payment_provider | id=4, name='MoMo', additional_settings='{"partnerCode":"MOMO04","accessKey":"key04","secretKey":"secret04","endpoint":"https://test-payment.momo.vn/v2/gateway/api","returnUrl":"http://api.yas.local/payment/callback","environment":"SANDBOX"}' |

---

### Scenario 5 — MoMo Sandbox config #5

| DB | Entity | Key values |
|----|--------|------------|
| payment | payment_provider | id=5, name='MoMo', additional_settings='{"partnerCode":"MOMO05","accessKey":"key05","secretKey":"secret05","endpoint":"https://test-payment.momo.vn/v2/gateway/api","returnUrl":"http://api.yas.local/payment/callback","environment":"SANDBOX"}' |

---

### Scenario 6 — MoMo Sandbox config #6

| DB | Entity | Key values |
|----|--------|------------|
| payment | payment_provider | id=6, name='MoMo', additional_settings='{"partnerCode":"MOMO06","accessKey":"key06","secretKey":"secret06","endpoint":"https://test-payment.momo.vn/v2/gateway/api","returnUrl":"http://api.yas.local/payment/callback","environment":"SANDBOX"}' |

---

### Scenario 7 — MoMo Sandbox config #7

| DB | Entity | Key values |
|----|--------|------------|
| payment | payment_provider | id=7, name='MoMo', additional_settings='{"partnerCode":"MOMO07","accessKey":"key07","secretKey":"secret07","endpoint":"https://test-payment.momo.vn/v2/gateway/api","returnUrl":"http://api.yas.local/payment/callback","environment":"SANDBOX"}' |

---

### Scenario 8 — MoMo Sandbox config #8

| DB | Entity | Key values |
|----|--------|------------|
| payment | payment_provider | id=8, name='MoMo', additional_settings='{"partnerCode":"MOMO08","accessKey":"key08","secretKey":"secret08","endpoint":"https://test-payment.momo.vn/v2/gateway/api","returnUrl":"http://api.yas.local/payment/callback","environment":"SANDBOX"}' |

---

### Scenario 9 — MoMo Sandbox config #9

| DB | Entity | Key values |
|----|--------|------------|
| payment | payment_provider | id=9, name='MoMo', additional_settings='{"partnerCode":"MOMO09","accessKey":"key09","secretKey":"secret09","endpoint":"https://test-payment.momo.vn/v2/gateway/api","returnUrl":"http://api.yas.local/payment/callback","environment":"SANDBOX"}' |

---

### Scenario 10 — MoMo Sandbox config #10

| DB | Entity | Key values |
|----|--------|------------|
| payment | payment_provider | id=10, name='MoMo', additional_settings='{"partnerCode":"MOMO10","accessKey":"key10","secretKey":"secret10","endpoint":"https://test-payment.momo.vn/v2/gateway/api","returnUrl":"http://api.yas.local/payment/callback","environment":"SANDBOX"}' |

---

### Scenario 11 — VNPay Sandbox config #1

| DB | Entity | Key values |
|----|--------|------------|
| payment | payment_provider | id=11, name='VNPay', additional_settings='{"tmnCode":"VNPAY01","hashSecret":"hsecret01","url":"https://sandbox.vnpayment.vn/paymentv2/vpcpay.html","returnUrl":"http://api.yas.local/payment/callback","environment":"SANDBOX"}' |

---

### Scenario 12 — VNPay Sandbox config #2

| DB | Entity | Key values |
|----|--------|------------|
| payment | payment_provider | id=12, name='VNPay', additional_settings='{"tmnCode":"VNPAY02","hashSecret":"hsecret02","url":"https://sandbox.vnpayment.vn/paymentv2/vpcpay.html","returnUrl":"http://api.yas.local/payment/callback","environment":"SANDBOX"}' |

---

### Scenario 13 — VNPay Sandbox config #3

| DB | Entity | Key values |
|----|--------|------------|
| payment | payment_provider | id=13, name='VNPay', additional_settings='{"tmnCode":"VNPAY03","hashSecret":"hsecret03","url":"https://sandbox.vnpayment.vn/paymentv2/vpcpay.html","returnUrl":"http://api.yas.local/payment/callback","environment":"SANDBOX"}' |

---

### Scenario 14 — VNPay Sandbox config #4

| DB | Entity | Key values |
|----|--------|------------|
| payment | payment_provider | id=14, name='VNPay', additional_settings='{"tmnCode":"VNPAY04","hashSecret":"hsecret04","url":"https://sandbox.vnpayment.vn/paymentv2/vpcpay.html","returnUrl":"http://api.yas.local/payment/callback","environment":"SANDBOX"}' |

---

### Scenario 15 — VNPay Sandbox config #5

| DB | Entity | Key values |
|----|--------|------------|
| payment | payment_provider | id=15, name='VNPay', additional_settings='{"tmnCode":"VNPAY05","hashSecret":"hsecret05","url":"https://sandbox.vnpayment.vn/paymentv2/vpcpay.html","returnUrl":"http://api.yas.local/payment/callback","environment":"SANDBOX"}' |

---

### Scenario 16 — VNPay Sandbox config #6

| DB | Entity | Key values |
|----|--------|------------|
| payment | payment_provider | id=16, name='VNPay', additional_settings='{"tmnCode":"VNPAY06","hashSecret":"hsecret06","url":"https://sandbox.vnpayment.vn/paymentv2/vpcpay.html","returnUrl":"http://api.yas.local/payment/callback","environment":"SANDBOX"}' |

---

### Scenario 17 — VNPay Sandbox config #7

| DB | Entity | Key values |
|----|--------|------------|
| payment | payment_provider | id=17, name='VNPay', additional_settings='{"tmnCode":"VNPAY07","hashSecret":"hsecret07","url":"https://sandbox.vnpayment.vn/paymentv2/vpcpay.html","returnUrl":"http://api.yas.local/payment/callback","environment":"SANDBOX"}' |

---

### Scenario 18 — VNPay Sandbox config #8

| DB | Entity | Key values |
|----|--------|------------|
| payment | payment_provider | id=18, name='VNPay', additional_settings='{"tmnCode":"VNPAY08","hashSecret":"hsecret08","url":"https://sandbox.vnpayment.vn/paymentv2/vpcpay.html","returnUrl":"http://api.yas.local/payment/callback","environment":"SANDBOX"}' |

---

### Scenario 19 — VNPay Sandbox config #9

| DB | Entity | Key values |
|----|--------|------------|
| payment | payment_provider | id=19, name='VNPay', additional_settings='{"tmnCode":"VNPAY09","hashSecret":"hsecret09","url":"https://sandbox.vnpayment.vn/paymentv2/vpcpay.html","returnUrl":"http://api.yas.local/payment/callback","environment":"SANDBOX"}' |

---

### Scenario 20 — VNPay Sandbox config #10

| DB | Entity | Key values |
|----|--------|------------|
| payment | payment_provider | id=20, name='VNPay', additional_settings='{"tmnCode":"VNPAY10","hashSecret":"hsecret10","url":"https://sandbox.vnpayment.vn/paymentv2/vpcpay.html","returnUrl":"http://api.yas.local/payment/callback","environment":"SANDBOX"}' |

---

### Scenario 21 — Stripe Test config #1

| DB | Entity | Key values |
|----|--------|------------|
| payment | payment_provider | id=21, name='Stripe', additional_settings='{"publishableKey":"pk_test_01","secretKey":"sk_test_01","webhookSecret":"whsec_01","currency":"vnd","environment":"TEST"}' |

---

### Scenario 22 — Stripe Test config #2

| DB | Entity | Key values |
|----|--------|------------|
| payment | payment_provider | id=22, name='Stripe', additional_settings='{"publishableKey":"pk_test_02","secretKey":"sk_test_02","webhookSecret":"whsec_02","currency":"vnd","environment":"TEST"}' |

---

### Scenario 23 — Stripe Test config #3

| DB | Entity | Key values |
|----|--------|------------|
| payment | payment_provider | id=23, name='Stripe', additional_settings='{"publishableKey":"pk_test_03","secretKey":"sk_test_03","webhookSecret":"whsec_03","currency":"vnd","environment":"TEST"}' |

---

### Scenario 24 — Stripe Test config #4

| DB | Entity | Key values |
|----|--------|------------|
| payment | payment_provider | id=24, name='Stripe', additional_settings='{"publishableKey":"pk_test_04","secretKey":"sk_test_04","webhookSecret":"whsec_04","currency":"usd","environment":"TEST"}' |

---

### Scenario 25 — Stripe Test config #5

| DB | Entity | Key values |
|----|--------|------------|
| payment | payment_provider | id=25, name='Stripe', additional_settings='{"publishableKey":"pk_test_05","secretKey":"sk_test_05","webhookSecret":"whsec_05","currency":"usd","environment":"TEST"}' |

---

### Scenario 26 — Stripe Test config #6

| DB | Entity | Key values |
|----|--------|------------|
| payment | payment_provider | id=26, name='Stripe', additional_settings='{"publishableKey":"pk_test_06","secretKey":"sk_test_06","webhookSecret":"whsec_06","currency":"vnd","environment":"TEST"}' |

---

### Scenario 27 — Stripe Test config #7

| DB | Entity | Key values |
|----|--------|------------|
| payment | payment_provider | id=27, name='Stripe', additional_settings='{"publishableKey":"pk_test_07","secretKey":"sk_test_07","webhookSecret":"whsec_07","currency":"vnd","environment":"TEST"}' |

---

### Scenario 28 — Stripe Test config #8

| DB | Entity | Key values |
|----|--------|------------|
| payment | payment_provider | id=28, name='Stripe', additional_settings='{"publishableKey":"pk_test_08","secretKey":"sk_test_08","webhookSecret":"whsec_08","currency":"usd","environment":"TEST"}' |

---

### Scenario 29 — Stripe Test config #9

| DB | Entity | Key values |
|----|--------|------------|
| payment | payment_provider | id=29, name='Stripe', additional_settings='{"publishableKey":"pk_test_09","secretKey":"sk_test_09","webhookSecret":"whsec_09","currency":"vnd","environment":"TEST"}' |

---

### Scenario 30 — Stripe Test config #10

| DB | Entity | Key values |
|----|--------|------------|
| payment | payment_provider | id=30, name='Stripe', additional_settings='{"publishableKey":"pk_test_10","secretKey":"sk_test_10","webhookSecret":"whsec_10","currency":"usd","environment":"TEST"}' |

---

### Scenario 31 — ZaloPay Sandbox config #1

| DB | Entity | Key values |
|----|--------|------------|
| payment | payment_provider | id=31, name='ZaloPay', additional_settings='{"appId":"zalo01","key1":"zkey1_01","key2":"zkey2_01","endpoint":"https://sb-openapi.zalopay.vn/v2/create","returnUrl":"http://api.yas.local/payment/callback","environment":"SANDBOX"}' |

---

### Scenario 32 — ZaloPay Sandbox config #2

| DB | Entity | Key values |
|----|--------|------------|
| payment | payment_provider | id=32, name='ZaloPay', additional_settings='{"appId":"zalo02","key1":"zkey1_02","key2":"zkey2_02","endpoint":"https://sb-openapi.zalopay.vn/v2/create","returnUrl":"http://api.yas.local/payment/callback","environment":"SANDBOX"}' |

---

### Scenario 33 — ZaloPay Sandbox config #3

| DB | Entity | Key values |
|----|--------|------------|
| payment | payment_provider | id=33, name='ZaloPay', additional_settings='{"appId":"zalo03","key1":"zkey1_03","key2":"zkey2_03","endpoint":"https://sb-openapi.zalopay.vn/v2/create","returnUrl":"http://api.yas.local/payment/callback","environment":"SANDBOX"}' |

---

### Scenario 34 — ZaloPay Sandbox config #4

| DB | Entity | Key values |
|----|--------|------------|
| payment | payment_provider | id=34, name='ZaloPay', additional_settings='{"appId":"zalo04","key1":"zkey1_04","key2":"zkey2_04","endpoint":"https://sb-openapi.zalopay.vn/v2/create","returnUrl":"http://api.yas.local/payment/callback","environment":"SANDBOX"}' |

---

### Scenario 35 — ZaloPay Sandbox config #5

| DB | Entity | Key values |
|----|--------|------------|
| payment | payment_provider | id=35, name='ZaloPay', additional_settings='{"appId":"zalo05","key1":"zkey1_05","key2":"zkey2_05","endpoint":"https://sb-openapi.zalopay.vn/v2/create","returnUrl":"http://api.yas.local/payment/callback","environment":"SANDBOX"}' |

---

### Scenario 36 — ZaloPay Sandbox config #6

| DB | Entity | Key values |
|----|--------|------------|
| payment | payment_provider | id=36, name='ZaloPay', additional_settings='{"appId":"zalo06","key1":"zkey1_06","key2":"zkey2_06","endpoint":"https://sb-openapi.zalopay.vn/v2/create","returnUrl":"http://api.yas.local/payment/callback","environment":"SANDBOX"}' |

---

### Scenario 37 — ZaloPay Sandbox config #7

| DB | Entity | Key values |
|----|--------|------------|
| payment | payment_provider | id=37, name='ZaloPay', additional_settings='{"appId":"zalo07","key1":"zkey1_07","key2":"zkey2_07","endpoint":"https://sb-openapi.zalopay.vn/v2/create","returnUrl":"http://api.yas.local/payment/callback","environment":"SANDBOX"}' |

---

### Scenario 38 — ZaloPay Sandbox config #8

| DB | Entity | Key values |
|----|--------|------------|
| payment | payment_provider | id=38, name='ZaloPay', additional_settings='{"appId":"zalo08","key1":"zkey1_08","key2":"zkey2_08","endpoint":"https://sb-openapi.zalopay.vn/v2/create","returnUrl":"http://api.yas.local/payment/callback","environment":"SANDBOX"}' |

---

### Scenario 39 — ZaloPay Sandbox config #9

| DB | Entity | Key values |
|----|--------|------------|
| payment | payment_provider | id=39, name='ZaloPay', additional_settings='{"appId":"zalo09","key1":"zkey1_09","key2":"zkey2_09","endpoint":"https://sb-openapi.zalopay.vn/v2/create","returnUrl":"http://api.yas.local/payment/callback","environment":"SANDBOX"}' |

---

### Scenario 40 — ZaloPay Sandbox config #10

| DB | Entity | Key values |
|----|--------|------------|
| payment | payment_provider | id=40, name='ZaloPay', additional_settings='{"appId":"zalo10","key1":"zkey1_10","key2":"zkey2_10","endpoint":"https://sb-openapi.zalopay.vn/v2/create","returnUrl":"http://api.yas.local/payment/callback","environment":"SANDBOX"}' |

---

### Scenario 41 — PayPal Sandbox config #1

| DB | Entity | Key values |
|----|--------|------------|
| payment | payment_provider | id=41, name='PayPal', additional_settings='{"clientId":"paypal_cid_01","clientSecret":"paypal_sec_01","currency":"USD","mode":"sandbox","returnUrl":"http://api.yas.local/payment/callback","environment":"SANDBOX"}' |

---

### Scenario 42 — PayPal Sandbox config #2

| DB | Entity | Key values |
|----|--------|------------|
| payment | payment_provider | id=42, name='PayPal', additional_settings='{"clientId":"paypal_cid_02","clientSecret":"paypal_sec_02","currency":"USD","mode":"sandbox","returnUrl":"http://api.yas.local/payment/callback","environment":"SANDBOX"}' |

---

### Scenario 43 — PayPal Sandbox config #3

| DB | Entity | Key values |
|----|--------|------------|
| payment | payment_provider | id=43, name='PayPal', additional_settings='{"clientId":"paypal_cid_03","clientSecret":"paypal_sec_03","currency":"USD","mode":"sandbox","returnUrl":"http://api.yas.local/payment/callback","environment":"SANDBOX"}' |

---

### Scenario 44 — PayPal Sandbox config #4

| DB | Entity | Key values |
|----|--------|------------|
| payment | payment_provider | id=44, name='PayPal', additional_settings='{"clientId":"paypal_cid_04","clientSecret":"paypal_sec_04","currency":"USD","mode":"sandbox","returnUrl":"http://api.yas.local/payment/callback","environment":"SANDBOX"}' |

---

### Scenario 45 — PayPal Sandbox config #5

| DB | Entity | Key values |
|----|--------|------------|
| payment | payment_provider | id=45, name='PayPal', additional_settings='{"clientId":"paypal_cid_05","clientSecret":"paypal_sec_05","currency":"USD","mode":"sandbox","returnUrl":"http://api.yas.local/payment/callback","environment":"SANDBOX"}' |

---

### Scenario 46 — PayPal Sandbox config #6

| DB | Entity | Key values |
|----|--------|------------|
| payment | payment_provider | id=46, name='PayPal', additional_settings='{"clientId":"paypal_cid_06","clientSecret":"paypal_sec_06","currency":"USD","mode":"sandbox","returnUrl":"http://api.yas.local/payment/callback","environment":"SANDBOX"}' |

---

### Scenario 47 — PayPal Sandbox config #7

| DB | Entity | Key values |
|----|--------|------------|
| payment | payment_provider | id=47, name='PayPal', additional_settings='{"clientId":"paypal_cid_07","clientSecret":"paypal_sec_07","currency":"USD","mode":"sandbox","returnUrl":"http://api.yas.local/payment/callback","environment":"SANDBOX"}' |

---

### Scenario 48 — PayPal Sandbox config #8

| DB | Entity | Key values |
|----|--------|------------|
| payment | payment_provider | id=48, name='PayPal', additional_settings='{"clientId":"paypal_cid_08","clientSecret":"paypal_sec_08","currency":"USD","mode":"sandbox","returnUrl":"http://api.yas.local/payment/callback","environment":"SANDBOX"}' |

---

### Scenario 49 — PayPal Sandbox config #9

| DB | Entity | Key values |
|----|--------|------------|
| payment | payment_provider | id=49, name='PayPal', additional_settings='{"clientId":"paypal_cid_09","clientSecret":"paypal_sec_09","currency":"USD","mode":"sandbox","returnUrl":"http://api.yas.local/payment/callback","environment":"SANDBOX"}' |

---

### Scenario 50 — PayPal Sandbox config #10

| DB | Entity | Key values |
|----|--------|------------|
| payment | payment_provider | id=50, name='PayPal', additional_settings='{"clientId":"paypal_cid_10","clientSecret":"paypal_sec_10","currency":"USD","mode":"sandbox","returnUrl":"http://api.yas.local/payment/callback","environment":"SANDBOX"}' |

---

<!-- END OF SCENARIO CATALOG -->
<!-- Batch complete: 10 of 10 data state groups covered. All 500 scenarios generated. -->
