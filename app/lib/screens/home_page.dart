import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> properties = [
    {
      "image": "https://source.unsplash.com/400x300/?apartment",
      "title": "Luxury Apartment",
      "location": "New York, NY",
      "price": 1500,
      "rooms": 3,
      "amenities": ["Wi-Fi", "Parking", "AC"]
    },
    {
      "image": "https://source.unsplash.com/400x300/?house",
      "title": "Cozy House",
      "location": "Los Angeles, CA",
      "price": 1200,
      "rooms": 2,
      "amenities": ["Wi-Fi", "AC"]
    },
    {
      "image": "https://source.unsplash.com/400x300/?pg",
      "title": "PG for Students",
      "location": "Boston, MA",
      "price": 500,
      "rooms": 1,
      "amenities": ["Wi-Fi"]
    }
  ];

  String? selectedLocation;
  String? selectedPrice;
  double selectedRooms = 1;
  List<String> selectedAmenities = [];

  List<String> locations = ["New York, NY", "Los Angeles, CA", "Boston, MA"];
  List<String> priceRanges = ["< \$800", "\$800 - \$1500", "> \$1500"];
  List<String> amenitiesOptions = ["Wi-Fi", "Parking", "AC"];

  List<Map<String, dynamic>> getFilteredProperties() {
    return properties.where((property) {
      if (selectedLocation != null && property["location"] != selectedLocation) return false;
      if (selectedPrice != null) {
        int price = property["price"];
        if (selectedPrice == "< \$800" && price >= 800) return false;
        if (selectedPrice == "\$800 - \$1500" && (price < 800 || price > 1500)) return false;
        if (selectedPrice == "> \$1500" && price <= 1500) return false;
      }
      if (property["rooms"] < selectedRooms) return false;
      if (selectedAmenities.isNotEmpty &&
          !selectedAmenities.every((amenity) => property["amenities"].contains(amenity))) {
        return false;
      }
      return true;
    }).toList();
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                children: [
                  // Title
                  const Text("Filters", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Divider(),

                  // 📍 Location Dropdown
                  DropdownButtonFormField<String>(
                    value: selectedLocation,
                    hint: const Text("Select Location"),
                    items: locations.map((location) {
                      return DropdownMenuItem(
                        value: location,
                        child: Text(location),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setModalState(() {
                        selectedLocation = value;
                      });
                    },
                  ),

                  const SizedBox(height: 10),

                  // 💰 Price Dropdown
                  DropdownButtonFormField<String>(
                    value: selectedPrice,
                    hint: const Text("Select Price Range"),
                    items: priceRanges.map((price) {
                      return DropdownMenuItem(
                        value: price,
                        child: Text(price),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setModalState(() {
                        selectedPrice = value;
                      });
                    },
                  ),

                  const SizedBox(height: 10),

                  // 🏡 Number of Rooms (Slider)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Number of Rooms"),
                      Slider(
                        value: selectedRooms,
                        min: 1,
                        max: 5,
                        divisions: 4,
                        label: selectedRooms.round().toString(),
                        onChanged: (value) {
                          setModalState(() {
                            selectedRooms = value;
                          });
                        },
                      ),
                    ],
                  ),

                  // 🏢 Amenities (Checkboxes)
                  const Text("Amenities"),
                  Wrap(
                    spacing: 10,
                    children: amenitiesOptions.map((amenity) {
                      return FilterChip(
                        label: Text(amenity),
                        selected: selectedAmenities.contains(amenity),
                        onSelected: (isSelected) {
                          setModalState(() {
                            if (isSelected) {
                              selectedAmenities.add(amenity);
                            } else {
                              selectedAmenities.remove(amenity);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  // Apply & Reset Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          setModalState(() {
                            selectedLocation = null;
                            selectedPrice = null;
                            selectedRooms = 1;
                            selectedAmenities.clear();
                          });
                        },
                        child: const Text("Reset"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {});
                          Navigator.pop(context);
                        },
                        child: const Text("Apply Filters"),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredProperties = getFilteredProperties();

    return Column(
      children: [
        // 🔍 Search & Filter Bar
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search properties...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // 🛠️ Filter Button
              IconButton(
                icon: const Icon(Icons.filter_list, size: 28),
                onPressed: _showFilterModal,
              ),
            ],
          ),
        ),

        // 🏠 Property Listings
        Expanded(
          child: filteredProperties.isEmpty
              ? const Center(child: Text("No properties found"))
              : ListView.builder(
                  itemCount: filteredProperties.length,
                  itemBuilder: (context, index) {
                    return PropertyCard(filteredProperties[index]);
                  },
                ),
        ),
      ],
    );
  }
}

// 📌 Property Card Widget
class PropertyCard extends StatelessWidget {
  final Map<String, dynamic> property;

  const PropertyCard(this.property, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(property["image"], height: 150, width: double.infinity, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(property["title"], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(property["location"], style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 5),
                Text("\$${property["price"]}/month", style: const TextStyle(fontSize: 16, color: Colors.green)),
                Text("Rooms: ${property["rooms"]}", style: const TextStyle(fontSize: 14, color: Colors.blueGrey)),
                Text("Amenities: ${property["amenities"].join(", ")}", style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
