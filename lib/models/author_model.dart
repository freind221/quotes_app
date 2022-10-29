class Results {
  String? sId;
  String? name;
  String? link;
  String? bio;
  String? description;
  int? quoteCount;
  String? slug;
  String? dateAdded;
  String? dateModified;

  Results(
      {this.sId,
      this.name,
      this.link,
      this.bio,
      this.description,
      this.quoteCount,
      this.slug,
      this.dateAdded,
      this.dateModified});

  Results.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    link = json['link'];
    bio = json['bio'];
    description = json['description'];
    quoteCount = json['quoteCount'];
    slug = json['slug'];
    dateAdded = json['dateAdded'];
    dateModified = json['dateModified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['link'] = link;
    data['bio'] = bio;
    data['description'] = description;
    data['quoteCount'] = quoteCount;
    data['slug'] = slug;
    data['dateAdded'] = dateAdded;
    data['dateModified'] = dateModified;
    return data;
  }
}
