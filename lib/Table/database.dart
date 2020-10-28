class User{
  int id;
  String name;
  String description;

  User({this.id,this.name,this.description});

  Map<String,dynamic> toMap(){
    return {'id': id,'name':name,'description':description};
  }
}