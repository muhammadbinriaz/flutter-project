part of '../lead_flow_home.dart';

extension _AppChromeTop on _LeadFlowHomeState {
  Widget _buildTopBar() {
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 26),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: LeadsColors.line)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: LeadsColors.forest,
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: const Text(
              'N',
              style: TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Leads MVP',
                style: TextStyle(
                  color: Color(0xFF20342C),
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  height: 1.1,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'L E A D   F L O W',
                style: TextStyle(
                  color: LeadsColors.muted,
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton.outlined(
            tooltip: 'Notifications',
            onPressed: _showNotifications,
            style: IconButton.styleFrom(
              foregroundColor: const Color(0xFF586D63),
              side: const BorderSide(color: LeadsColors.line),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: const Icon(Icons.notifications_none_rounded, size: 22),
          ),
        ],
      ),
    );
  }


}
