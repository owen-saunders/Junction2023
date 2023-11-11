import 'dart:core';

class Challenge {
  final int id;
  final String title;
  final String shortDesc;
  final String startDate;
  final String endDate;
  final int sponsor;
  final int owner;
  final String photo;
  final int participants;
  final String proof;
  final String longDesc;
  final String reward;
  final double emissions;
  final double water;
  final double energy;
  final double plastic;
  final double trees;

  Challenge(
      {this.id = -1,
      this.title = '',
      this.shortDesc = '',
      this.longDesc = '',
      this.proof = '',
      this.reward = '',
      this.startDate = '',
      this.endDate = '',
      this.sponsor = -1,
      this.owner = -1,
      this.photo = '',
      this.participants = -1,
      this.emissions = 0,
      this.water = 0,
      this.plastic = 0,
      this.trees = 0,
      this.energy = 0});

  factory Challenge.fromJson(Map<String, dynamic> responseData) {
    return Challenge(
        id: responseData['id'],
        title: responseData['title'],
        shortDesc: responseData['short_description'],
        longDesc: responseData['long_description'],
        startDate: responseData['start_date'],
        endDate: responseData['end_date'],
        reward: responseData['reward'],
        proof: responseData['proof'],
        sponsor: responseData['sponsor'],
        owner: responseData['owner'],
        photo: responseData['photo'],
        participants: responseData['participants'],
        emissions: responseData['emissions'],
        water: responseData['water'],
        plastic: responseData['plastic'],
        trees: responseData['trees'],
        energy: responseData['energy']);
  }

  @override
  String toString() {
    return 'Challenge: $title';
  }
}
