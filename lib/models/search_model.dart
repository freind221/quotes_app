class Searches {
  int? sId;
  String? content;
  String? author;
  List<String>? tags;
  String? authorId;
  String? authorSlug;
  int? length;
  String? dateAdded;
  String? dateModified;

  Searches(
      {this.sId,
      this.content,
      this.author,
      this.tags,
      this.authorId,
      this.authorSlug,
      this.length,
      this.dateAdded,
      this.dateModified});

  Searches.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    content = json['content'];
    author = json['author'];
    tags = json['tags'].cast<String>();
    authorId = json['authorId'];
    authorSlug = json['authorSlug'];
    length = json['length'];
    dateAdded = json['dateAdded'];
    dateModified = json['dateModified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['content'] = content;
    data['author'] = author;
    data['tags'] = tags;
    data['authorId'] = authorId;
    data['authorSlug'] = authorSlug;
    data['length'] = length;
    data['dateAdded'] = dateAdded;
    data['dateModified'] = dateModified;
    return data;
  }

  Searches.fromMap(Map<String, dynamic> res)
      : sId = res['_id'],
        content = res['content'],
        author = res['author'],
        authorId = res['authorId'],
        authorSlug = res['authorSlug'],
        length = res['length'],
        dateAdded = res['dateAdded'],
        dateModified = res['dateModified'];

  Map<String, Object?> toMap() {
    return {
      '_id': sId,
      'content': content,
      'author': author,
      'authorId': authorId,
      'authorSlug': authorSlug,
      'length': length,
      'dateAdded': dateAdded,
      'dateModified': dateModified,
    };
  }
}
