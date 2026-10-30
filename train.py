from ultralytics import YOLO
import os

def train_model():
    print("🚀 YOLOv8 Kaçak Pano Eğitim Modülü Başlatılıyor...")
    model = YOLO('yolov8n.pt')  # Hafif ve güçlü ön eğitilmiş model

    if not os.path.exists('dataset.yaml'):
        print("⚠️ dataset.yaml bulunamadı!")
        return

    model.train(
        data='dataset.yaml',
        epochs=50,
        imgsz=640,
        batch=16,
        name='kacak_pano_v1'
    )
    print("✅ Eğitim tamamlandı, model kaydedildi!")
    model.export(format='tflite') # Mobil için dışa aktar

if __name__ == '__main__':
    train_model()
