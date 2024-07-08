import 'package:flutter/material.dart';
import 'package:contactbook_app/src/pages/world_time.dart';

class ChooseLocation extends StatefulWidget {
  const ChooseLocation({super.key});

  @override
  State<ChooseLocation> createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {
  List<WorldTime> locations = [
    WorldTime(location: 'London', url: 'Europe/London', flag: 'uk.png'),
    WorldTime(location: 'Athens', url: 'Europe/Athens', flag: 'greece.png'),
    WorldTime(location: 'Cairo', url: 'Africa/Cairo', flag: 'egypt.png'),
    WorldTime(location: 'Nairobi', url: 'Africa/Nairobi', flag: 'kenya.png'),
    WorldTime(location: 'India', url: 'Indian/Chagos', flag: 'india.png'),
    WorldTime(location: 'New York', url: 'America/New_York', flag: 'germany.png'),
    WorldTime(location: 'Jakarta', url: 'Asia/Jakarta', flag: 'indonesia.png'),
    WorldTime(location: 'Seoul', url: 'Asia/Seoul', flag: 'south_korea.png'),
    WorldTime(location: 'Chicago', url: 'America/Chicago', flag: 'usa.png'),
  ];

  void updateTime(index) async {
    WorldTime instance = locations[index];
    await instance.getTime();
    Navigator.pop(context, {
      'location': instance.location,
      'flag': instance.flag,
      'time': instance.time,
      'isDayTime': instance.isDayTime,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Location'),
      ),
      body: ListView.builder(
        itemCount: locations.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
            child: Card(
              child: ListTile(
                onTap: () {
                  updateTime(index);
                },
                title: Text(locations[index].location),
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/${locations[index].flag}'),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
