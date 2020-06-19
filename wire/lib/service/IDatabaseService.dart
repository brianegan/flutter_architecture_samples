abstract class IDatabaseService {
  Future init([String key]);
  bool exist(String key);
  dynamic retrieve(String key);
  void save(String key, dynamic data);
}