class Cat {
  final List? breeds;
  final String? id;
  final String? url;
  final int? width;
  final int? height;

  Cat({this.breeds, this.id, this.url, this.width, this.height});

  Cat.fromJson(Map<String, dynamic> json)
      : breeds = json['breeds'],
    id = json['id'],
    url = json['url'],
    width = json['width'],
    height = json['height'];
}