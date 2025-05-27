import 'package:mentorai/Assets/image.dart';

class Category {
  String id;
  String name;
  String image;
  Category({required this.id, required this.name, required this.image});
}

List<Category> categoriesList = [
  Category(id: '1', name: '8/9/10', image: AppImages.kGoogle),
  Category(id: '2', name: '+1/+2', image: AppImages.kGoogle),
  Category(id: '3', name: 'Engineering', image: AppImages.kGoogle),
  Category(id: '4', name: 'Coding', image: AppImages.kGoogle),
  Category(id: '5', name: 'Others', image: AppImages.kGoogle),
];