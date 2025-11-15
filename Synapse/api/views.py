import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'

from django.conf import settings
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from api.model.inference import Model

# load model strawberry
MODEL_PATH = os.path.join(settings.BASE_DIR, "api", "model", "garden", "model_strawberry.h5")
print(f"Loading model dari: {MODEL_PATH}")
model = Model.from_path(MODEL_PATH)

@csrf_exempt
def predict_image(request):
    if request.method != "POST":
        return JsonResponse({"error": "Gunakan metode POST"}, status=405)

    if "image" not in request.FILES:
        return JsonResponse({"error": "File gambar tidak ditemukan"}, status=400)

    image_file = request.FILES["image"]

    try:
        hasil_prediksi = model.prediksi_gambar(image_file)
        return JsonResponse({
            "status": "berhasil",
            "message": "Prediksi berhasil diproses",
            "data": hasil_prediksi
        }, status=200)
    except Exception as e:
        return JsonResponse({
            "status": "gagal",
            "error": str(e)
        }, status=500)