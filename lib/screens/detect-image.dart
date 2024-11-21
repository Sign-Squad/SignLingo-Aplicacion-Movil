import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<String?> uploadImage(File imageFile) async {
  try {
    // Convertir la imagen a Base64
    final bytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(bytes);
    final postData = utf8.encode(base64Image);

    // Configurar la solicitud
    final url = Uri.parse(
        "https://detect.roboflow.com/american-sign-language-v36cz/1?api_key=VBpTkFBTwED0IYlB4Jau&name=YOUR_IMAGE.jpg");
    final headers = {"Content-Type": "application/x-www-form-urlencoded"};

    final response = await http.post(
      url,
      headers: headers,
      body: postData,
    );

    // Validar la respuesta
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      print("Respuesta del servidor: $responseData");

      // Extraer la clase detectada de las predicciones
      if (responseData['predictions'] != null &&
          responseData['predictions'].isNotEmpty) {
        return responseData['predictions'][0]['class'] as String?;
      }
      return null; // No hay predicciones disponibles
    } else {
      print("Error: ${response.statusCode}, ${response.body}");
      return null;
    }
  } catch (e) {
    print("Error al cargar la imagen: $e");
    return null; // En caso de error
  }
}
