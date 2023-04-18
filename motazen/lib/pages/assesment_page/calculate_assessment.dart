import 'package:motazen/entities/aspect.dart';
import 'package:motazen/isar_service.dart';
import '../select_aspectPage/handle_aspect_data.dart';

class CalculateAspectPoints {
  calculateAllpoints(List questionData) async {
    double aspectPoints;
    List<Aspect> aspects = await HandleAspect().getSelectedAspects();
    for (var aspect in aspects) {
      //set to zero at the start for each element
      double sum = 0;
      //find the number of questions for each aspect
      int counter = 0;
      for (var element in questionData) {
        if (aspect.name == element['aspect']) {
          //find the sum for the points
          sum += element['points'];
          counter = counter + 10; //always increse by 10
        }
      }
      //calculate the pointer
      aspectPoints = (sum / counter) * 100;
      await IsarService().assignPointAspect(aspect.name, aspectPoints);
    }
  }
}
