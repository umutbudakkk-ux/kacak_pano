import cv2
from ultralytics import YOLO

def detect_kacak(image_path):
    model_path = 'runs/detect/kacak_pano_v1/weights/best.pt'
    if not cv2.os.path.exists(model_path):
        print("⚠️ Eğitilmiş model (best.pt) henüz yok! Önce train.py çalıştırmalısın.")
        return

    model = YOLO(model_path)
    results = model(image_path)
    img = cv2.imread(image_path)

    alarm_verildi = False

    for r in results:
        for box in r.boxes:
            cls_id = int(box.cls[0])
            conf = float(box.conf[0])
            class_name = model.names[cls_id]
            x1, y1, x2, y2 = map(int, box.xyxy[0])

            if class_name in ['kacak_jumper', 'mudahale_anomalisi'] and conf > 0.45:
                alarm_verildi = True
                cv2.rectangle(img, (x1, y1), (x2, y2), (0, 0, 255), 3)
                cv2.putText(img, f"KACAK! %{conf*100:.1f}", (x1, y1 - 10), 
                            cv2.FONT_HERSHEY_SIMPLEX, 0.6, (0, 0, 255), 2)
            else:
                cv2.rectangle(img, (x1, y1), (x2, y2), (0, 255, 0), 2)

    if alarm_verildi:
        print("\n🚨 -------------------------------------------------- 🚨")
        print("🚨 KRİTİK UYARI: Panoda Kaçak / Jumper Kablo Tespit Edildi! 🚨")
        print("🚨 -------------------------------------------------- 🚨")
    else:
        print("\n✅ Pano Temiz.")

    cv2.imwrite("sonuc_analiz.jpg", img)
    print("📸 İşaretlenmiş görsel 'sonuc_analiz.jpg' olarak kaydedildi.")

if __name__ == '__main__':
    pass
