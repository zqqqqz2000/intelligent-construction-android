import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intelligent_construction/component/pic.dart';
import 'package:intelligent_construction/provider.dart';
import 'package:timelines/timelines.dart';

class ProjectTimeline extends StatelessWidget {
  Processes processes;

  ProjectTimeline(this.processes);

  @override
  Widget build(BuildContext context) {
    var processesList = processes.getProcesses();
    return Container(
      child: FixedTimeline(
        children: [
          OutlinedDotIndicator(),
          FixedTimeline.tileBuilder(
            builder: TimelineTileBuilder.connectedFromStyle(
              contentsAlign: ContentsAlign.alternating,
              oppositeContentsBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(processesList[index].date),
              ),
              contentsBuilder: (context, index) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(processesList[index].comment),
                      Pic(processesList[index].pic, 50, 50),
                    ],
                  ),
                ),
              ),
              connectorStyleBuilder: (context, index) =>
                  ConnectorStyle.solidLine,
              indicatorStyleBuilder: (context, index) => IndicatorStyle.dot,
              itemCount: processesList != null ? processesList.length : 0,
            ),
          ),
        ],
      ),
    );
  }
}
