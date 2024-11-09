import 'package:ctmap/assets/colors/colors.dart';
import 'package:ctmap/assets/icons/icons.dart';
import 'package:ctmap/data/accident_level_data.dart';
import 'package:flutter/material.dart';

class InfoSheet extends StatelessWidget {
  const InfoSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.zero,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Chú thích',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.red,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(AppIcons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              for(int i = 0; i < accidentLevels.length; i++)
                _buildInfoRow(i),
            ]
          ),
        ),
      
    );
    
  }
  Widget _buildInfoRow(int level) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            NumberedLocationIcon(
              iconData: AppIcons.location, 
              number: level + 1
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
              accidentLevels[level].name, 
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: 'Mulish',
                overflow: TextOverflow.visible,
              ),
              maxLines: 2,
            )
            )
          ],
        ),
        Text(
          accidentLevels[level].detail, 
          style: const TextStyle(
            fontSize: 12,
            fontFamily: 'Mulish',
          ),
        )
      ],
    );
  }
}