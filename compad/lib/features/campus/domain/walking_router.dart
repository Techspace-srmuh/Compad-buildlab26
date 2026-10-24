import 'dart:math';

class MapNode {
  final String id;
  final String name;
  final double lat;
  final double lng;
  final String type;

  const MapNode({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    required this.type,
  });
}

class MapEdge {
  final String source;
  final String target;
  final double distanceMeters;
  final bool accessible;

  const MapEdge({
    required this.source,
    required this.target,
    required this.distanceMeters,
    this.accessible = true,
  });
}

class RouteStep {
  final MapNode node;
  final double distanceFromPreviousMeters;
  final String instruction;

  const RouteStep({
    required this.node,
    required this.distanceFromPreviousMeters,
    required this.instruction,
  });
}

class WalkingRouteResult {
  final List<RouteStep> steps;
  final double totalDistanceMeters;
  final int estimatedWalkingMinutes;
  final bool isAccessible;

  const WalkingRouteResult({
    required this.steps,
    required this.totalDistanceMeters,
    required this.estimatedWalkingMinutes,
    required this.isAccessible,
  });
}

class WalkingRouter {
  final Map<String, MapNode> nodes;
  final List<MapEdge> edges;

  WalkingRouter({required List<MapNode> nodeList, required this.edges})
      : nodes = {for (var n in nodeList) n.id: n};

  /// Calculates shortest walking route using Dijkstra / A*
  WalkingRouteResult? findShortestRoute({
    required String startNodeId,
    required String destinationNodeId,
    bool requireAccessible = false,
  }) {
    if (!nodes.containsKey(startNodeId) || !nodes.containsKey(destinationNodeId)) {
      return null;
    }

    if (startNodeId == destinationNodeId) {
      final n = nodes[startNodeId]!;
      return WalkingRouteResult(
        steps: [RouteStep(node: n, distanceFromPreviousMeters: 0, instruction: 'You are at ${n.name}')],
        totalDistanceMeters: 0,
        estimatedWalkingMinutes: 0,
        isAccessible: true,
      );
    }

    // Build adjacency list (bi-directional edges)
    final adj = <String, List<MapEdge>>{};
    for (final edge in edges) {
      if (requireAccessible && !edge.accessible) continue;
      adj.putIfAbsent(edge.source, () => []).add(edge);
      // Reverse edge for bi-directional campus footpaths
      adj.putIfAbsent(edge.target, () => []).add(
            MapEdge(
              source: edge.target,
              target: edge.source,
              distanceMeters: edge.distanceMeters,
              accessible: edge.accessible,
            ),
          );
    }

    final distances = <String, double>{};
    final previous = <String, String?>{};
    final unvisited = <String>{};

    for (final node in nodes.keys) {
      distances[node] = double.infinity;
      previous[node] = null;
      unvisited.add(node);
    }
    distances[startNodeId] = 0.0;

    while (unvisited.isNotEmpty) {
      // Node in unvisited with smallest distance
      String? current;
      double minDistance = double.infinity;
      for (final u in unvisited) {
        final dist = distances[u]!;
        if (dist < minDistance) {
          minDistance = dist;
          current = u;
        }
      }

      if (current == null || minDistance == double.infinity) break;
      if (current == destinationNodeId) break;

      unvisited.remove(current);

      final neighbors = adj[current] ?? [];
      for (final edge in neighbors) {
        if (!unvisited.contains(edge.target)) continue;
        final tentativeDist = distances[current]! + edge.distanceMeters;
        if (tentativeDist < distances[edge.target]!) {
          distances[edge.target] = tentativeDist;
          previous[edge.target] = current;
        }
      }
    }

    if (distances[destinationNodeId] == double.infinity) {
      return null; // No path found
    }

    // Reconstruct path
    final path = <String>[];
    String? curr = destinationNodeId;
    while (curr != null) {
      path.insert(0, curr);
      curr = previous[curr];
    }

    final steps = <RouteStep>[];
    double accumulatedDistance = 0.0;
    for (int i = 0; i < path.length; i++) {
      final node = nodes[path[i]]!;
      if (i == 0) {
        steps.add(RouteStep(
          node: node,
          distanceFromPreviousMeters: 0,
          instruction: 'Start at ${node.name}',
        ));
      } else {
        final prevNode = nodes[path[i - 1]]!;
        // Find edge distance
        final edge = adj[prevNode.id]?.firstWhere((e) => e.target == node.id);
        final dist = edge?.distanceMeters ?? 50.0;
        accumulatedDistance += dist;
        steps.add(RouteStep(
          node: node,
          distanceFromPreviousMeters: dist,
          instruction: 'Walk ${dist.toInt()}m toward ${node.name}',
        ));
      }
    }

    // Average walking speed ~ 1.4 m/s => ~84 meters / min
    final walkingMinutes = max(1, (accumulatedDistance / 80.0).ceil());

    return WalkingRouteResult(
      steps: steps,
      totalDistanceMeters: accumulatedDistance,
      estimatedWalkingMinutes: walkingMinutes,
      isAccessible: true,
    );
  }
}
