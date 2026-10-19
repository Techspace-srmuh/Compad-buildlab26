class SharingHistoryModel {
  final String id;
  final String title;
  final String payloadType;
  final String direction; // 'SENT' or 'RECEIVED'
  final String transport; // 'Wi-Fi' or 'Bluetooth'
  final String peerInfo;
  final String timestamp;
  final int itemCount;
  final String? rawJson;

  const SharingHistoryModel({
    required this.id,
    required this.title,
    required this.payloadType,
    required this.direction,
    required this.transport,
    required this.peerInfo,
    required this.timestamp,
    required this.itemCount,
    this.rawJson,
  });

  bool get isSent => direction == 'SENT';
  bool get isWifi => transport.toUpperCase().contains('WI-FI') || transport.toUpperCase().contains('WIFI');

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'payload_type': payloadType,
      'direction': direction,
      'transport': transport,
      'peer_info': peerInfo,
      'timestamp': timestamp,
      'item_count': itemCount,
      'raw_json': rawJson,
    };
  }

  factory SharingHistoryModel.fromMap(Map<String, dynamic> map) {
    return SharingHistoryModel(
      id: map['id'] as String,
      title: map['title'] as String,
      payloadType: map['payload_type'] as String,
      direction: map['direction'] as String,
      transport: map['transport'] as String,
      peerInfo: map['peer_info'] as String,
      timestamp: map['timestamp'] as String,
      itemCount: map['item_count'] as int? ?? 1,
      rawJson: map['raw_json'] as String?,
    );
  }
}
