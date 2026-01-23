import 'package:flutter/material.dart';

class RecyclingGuidePage extends StatelessWidget {
  const RecyclingGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Recycling Guide",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.green,
          iconTheme: const IconThemeData(color: Colors.white),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(icon: Icon(Icons.check_circle_outline), text: "Recyclable"),
              Tab(icon: Icon(Icons.cancel_outlined), text: "Not Recyclable"),
              Tab(icon: Icon(Icons.build_circle_outlined), text: "Preparation"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            RecyclableTab(),
            NonRecyclableTab(),
            PreparationTab(),
          ],
        ),
      ),
    );
  }
}

class RecyclableTab extends StatelessWidget {
  const RecyclableTab({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {
        "name": "Paper & Cardboard",
        "desc": "Newspapers, magazines, office paper, cardboard boxes, brown paper bags, envelopes.",
        "details": "• Flatten boxes for easier transport\n• Remove plastic windows from envelopes\n• Do not include waxed or laminated paper\n• Dry paper only - no wet cardboard",
        "icon": Icons.newspaper,
        "image": "https://images.unsplash.com/photo-1581092918056-0c4c3acd3789?w=400&h=300&fit=crop"
      },
      {
        "name": "Plastic Bottles & Containers",
        "desc": "Water bottles, soda bottles, milk jugs, plastic containers (PET & HDPE types).",
        "details": "• Rinse bottles thoroughly to remove food residue\n• Remove bottle caps (they can jam machinery)\n• Flatten bottles to save space\n• Check for recycling symbols #1, #2, #5",
        "icon": Icons.local_drink,
        "image": "https://images.unsplash.com/photo-1559027615-cd3628902d4a?w=400&h=300&fit=crop"
      },
      {
        "name": "Glass Containers",
        "desc": "Glass jars, bottles, drinking glasses (intact only).",
        "details": "• Rinse thoroughly to remove all contents\n• Keep glass intact - broken glass is hazardous\n• Remove metal/plastic lids and caps\n• All colors accepted: clear, brown, green\n• Glass recycled into new bottles or insulation",
        "icon": Icons.wine_bar,
        "image": "https://images.unsplash.com/photo-1578500494198-246f612d03b3?w=400&h=300&fit=crop"
      },
      {
        "name": "Metal Cans & Aluminum",
        "desc": "Aluminum cans, steel cans, tin cans, aluminum foil (clean).",
        "details": "• Rinse aluminum and steel cans\n• Flatten cans to save space\n• Remove food labels if possible\n• Aluminum foil should be clean and bundled\n• Magnets separate steel from aluminum",
        "icon": Icons.takeout_dining,
        "image": "https://images.unsplash.com/photo-1578500494198-246f612d03b3?w=400&h=300&fit=crop"
      },
      {
        "name": "Textiles & Clothing",
        "desc": "Clean clothing, shoes, blankets, towels in good condition.",
        "details": "• Ensure items are clean and dry\n• Donate usable clothing to thrift stores\n• Worn items can be recycled into insulation\n• Keep textiles separate from other recyclables",
        "icon": Icons.checkroom,
        "image": "https://images.unsplash.com/photo-1556821552-5f3fee3c3c2d?w=400&h=300&fit=crop"
      },
      {
        "name": "Electronics (Selected)",
        "desc": "Old computers, laptops, smartphones, tablets (with proper handling).",
        "details": "• Take to specialized e-waste recycling centers\n• Erase personal data before recycling\n• Keep away from regular recycling bins\n• Contains valuable materials and toxic substances",
        "icon": Icons.devices,
        "image": "https://images.unsplash.com/photo-1597872200969-2b65d56bd16b?w=400&h=300&fit=crop"
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          child: ExpansionTile(
            leading: SizedBox(
              width: 50,
              height: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item['image'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return CircleAvatar(
                      backgroundColor: Colors.green.withValues(alpha: 0.1),
                      child: Icon(item['icon'], color: Colors.green),
                    );
                  },
                ),
              ),
            ),
            title: Text(item['name'],
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(item['desc']),
            trailing: const Icon(Icons.check_circle, color: Colors.green),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Processing Tips:",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['details'],
                      style: TextStyle(color: Colors.grey[700], fontSize: 12, height: 1.6),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class NonRecyclableTab extends StatelessWidget {
  const NonRecyclableTab({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {
        "name": "Plastic Bags",
        "desc": "Grocery bags, plastic wrap, cling film (jam recycling machines).",
        "details": "• Gets tangled in sorting machinery\n• Causes production shutdowns\n• Reuse for trash liners or storage\n• Dispose in regular trash or specialty programs",
        "icon": Icons.shopping_bag,
        "image": "https://images.unsplash.com/photo-1559027615-cd3628902d4a?w=400&h=300&fit=crop"
      },
      {
        "name": "Styrofoam & Polystyrene",
        "desc": "Foam cups, takeout containers, packing peanuts, insulation foam.",
        "details": "• Not economical to recycle in most areas\n• Takes 500+ years to decompose\n• Takes up valuable landfill space\n• Use reusable containers for takeout\n• Some specialized facilities accept foam",
        "icon": Icons.coffee,
        "image": "https://images.unsplash.com/photo-1578500494198-246f612d03b3?w=400&h=300&fit=crop"
      },
      {
        "name": "Contaminated Food Waste",
        "desc": "Food residue, grease, cooking oil, pizza boxes with grease.",
        "details": "• Contaminates entire batches of recyclables\n• Causes odor and attracts pests\n• Compost organic food waste instead\n• Use separate bins for food disposal\n• Clean containers before recycling",
        "icon": Icons.fastfood,
        "image": "https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=400&h=300&fit=crop"
      },
      {
        "name": "Hazardous Materials",
        "desc": "Batteries, light bulbs, paint, chemicals, oils, solvents.",
        "details": "• Toxic to environment and workers\n• Take to hazardous waste facilities\n• Batteries: Search for e-waste drop-off centers\n• Paint: Check for take-back programs\n• Never mix with regular trash or recycling",
        "icon": Icons.battery_alert,
        "image": "https://images.unsplash.com/photo-1532996122724-8f3c4e6a0e9b?w=400&h=300&fit=crop"
      },
      {
        "name": "Broken Glass & Ceramics",
        "desc": "Broken mirrors, windows, drinking glasses, dishware.",
        "details": "• Dangerous to sorting facility workers\n• Different melting points than bottles\n• Can contaminate paper and cardboard\n• Wrap in newspaper before trash disposal\n• Use separate disposal for sharp glass",
        "icon": Icons.broken_image,
        "image": "https://images.unsplash.com/photo-1578500494198-246f612d03b3?w=400&h=300&fit=crop"
      },
      {
        "name": "Rubber & Leather",
        "desc": "Tires, rubber bands, leather products, hoses.",
        "details": "• Cannot be processed in standard facilities\n• Tires: Take to tire shops for recycling\n• Leather: Donate usable items to thrift stores\n• Rubber hoses: Check specialty centers\n• Most items end up in landfill",
        "icon": Icons.tire_repair,
        "image": "https://images.unsplash.com/photo-1595358871676-52c75f1be3e5?w=400&h=300&fit=crop"
      },
      {
        "name": "Coated or Treated Items",
        "desc": "Waxed cardboard, laminated materials, treated wood.",
        "details": "• Coating prevents recycling process\n• Contaminates recycled material quality\n• Milk cartons: Some areas accept separately\n• Treated wood: Only for specialized recycling\n• Check local guidelines for specifics",
        "icon": Icons.mood,
        "image": "https://images.unsplash.com/photo-1596177597696-2d19e2ddda45?w=400&h=300&fit=crop"
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          child: ExpansionTile(
            leading: SizedBox(
              width: 50,
              height: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item['image'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return CircleAvatar(
                      backgroundColor: Colors.red.withValues(alpha: 0.1),
                      child: Icon(item['icon'], color: Colors.red),
                    );
                  },
                ),
              ),
            ),
            title: Text(item['name'],
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(item['desc']),
            trailing: const Icon(Icons.cancel, color: Colors.red),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Why Not Recyclable:",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['details'],
                      style: TextStyle(color: Colors.grey[700], fontSize: 12, height: 1.6),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class PreparationTab extends StatelessWidget {
  const PreparationTab({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> steps = [
      {
        "title": "1. Rinse & Clean",
        "desc":
            "Wash out all food residue from cans, bottles, and jars to prevent contamination and odor. Dry items before placing in bin.",
        "icon": Icons.water_drop,
        "importance": "CRITICAL - Contamination ruins entire batches"
      },
      {
        "title": "2. Flatten & Compress",
        "desc":
            "Break down cardboard boxes and flatten plastic bottles to save space. This reduces truck trips and landfill impact.",
        "icon": Icons.layers,
        "importance": "Saves collection costs and fuel"
      },
      {
        "title": "3. Remove Non-Recyclable Parts",
        "desc":
            "Take off plastic caps from bottles, remove metal lids from jars, separate materials when possible (e.g., remove labels).",
        "icon": Icons.delete_outline,
        "importance": "Prevents machinery jams and contamination"
      },
      {
        "title": "4. Keep it Loose",
        "desc":
            "DO NOT bag your recyclables. Place items directly into the bin. Plastic bags jam sorting machinery and cause costly shutdowns.",
        "icon": Icons.no_backpack,
        "importance": "CRITICAL - Bagged items shut down facilities"
      },
      {
        "title": "5. Separate by Material",
        "desc":
            "Keep different materials separate when your facility requires it. Some areas want paper separate from plastics and metals.",
        "icon": Icons.source,
        "importance": "Check your local recycling guidelines"
      },
      {
        "title": "6. Check Local Guidelines",
        "desc":
            "Recycling rules vary by location and facility. Call your local center or visit their website to confirm what they accept.",
        "icon": Icons.location_on,
        "importance": "When in doubt, leave it out!"
      },
      {
        "title": "7. Dispose of Hazardous Items Properly",
        "desc":
            "Take batteries, electronics, paint, and chemicals to specialized hazardous waste facilities. Never mix with regular recycling.",
        "icon": Icons.warning,
        "importance": "Environmental and safety concern"
      },
      {
        "title": "8. Composting Alternatives",
        "desc":
            "Compost organic waste like food scraps and yard debris. Many cities offer composting programs to divert waste from landfills.",
        "icon": Icons.eco,
        "importance": "Reduces landfill methane emissions"
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: steps.length,
      itemBuilder: (context, index) {
        final step = steps[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blue.withValues(alpha: 0.1),
                      child: Icon(step['icon'], color: Colors.blue),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        step['title'],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  step['desc'],
                  style: TextStyle(color: Colors.grey[700], height: 1.6),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.05),
                    border: Border(left: BorderSide(color: Colors.blue, width: 3)),
                  ),
                  child: Text(
                    "💡 ${step['importance']}",
                    style: const TextStyle(
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
