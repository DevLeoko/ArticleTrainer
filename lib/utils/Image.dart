class Image {
  final String imageId;
  final String displayUrl;
  final String downloadUrl;
  final String userId;
  final String username;
  final String userLink;

  Image(this.imageId, this.displayUrl, this.downloadUrl, this.userId,
      this.username, this.userLink);

  Map<String, dynamic> toMap() {
    return {
      'imageId': imageId,
      'displayUrl': displayUrl,
      'downloadUrl': downloadUrl,
      'userId': userId,
      'username': username,
      'userLink': userLink,
    };
  }

  static Image fromMap(Map<String, dynamic> map) {
    return Image(
      map['imageId'],
      map['displayUrl'],
      map['downloadUrl'],
      map['userId'],
      map['username'],
      map['userLink'],
    );
  }
}
