import numpy as np
from PIL import Image
from tensorflow.keras.models import load_model
from tensorflow.keras.applications.efficientnet import preprocess_input

class Model:
    def __init__(self, model):
        self.model = model

    @classmethod
    def from_path(cls, model_path):
        model = load_model(model_path, compile=False)
        print(f"Model berhasil dimuat dari: {model_path}")
        return cls(model)

    def _siapkan_gambar(self, image_file, target_size=(224, 224)):
        img = Image.open(image_file).convert("RGB")
        img = img.resize(target_size)
        arr = np.array(img).astype(np.float32)
        arr = preprocess_input(arr)
        arr = np.expand_dims(arr, axis=0)
        return arr, img

    def prediksi_gambar(self, image_file):
        img_array, pil_img = self._siapkan_gambar(image_file)
        pred = float(self.model.predict(img_array, verbose=0)[0][0])  

        # label dan akurasi
        if pred > 0.5:
            label = "unripe"
            confidence = pred * 100
        else:
            label = "ripe"
            confidence = (1 - pred) * 100

        # warna dominan
        img_arr_255 = np.array(pil_img).astype(np.float32) / 255.0
        mean_rgb = img_arr_255.mean(axis=(0, 1))
        r, g, b = mean_rgb
        if r > g and r > b:
            warna_dominan = "merah" if r > 0.5 else "merah muda"
        elif g > r and g > b:
            warna_dominan = "hijau"
        else:
            warna_dominan = "kuning"

        # tekstur
        tekstur = "lembek" if label == "ripe" else "keras"

        # data dikirim
        return {
            "Label": label,
            "Akurasi": f"{confidence:.0f}%",
            "Warna_dominan": warna_dominan,
            "Texture": tekstur,
        }