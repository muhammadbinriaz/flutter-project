part of '../lead_flow_home.dart';

extension _AppChromeBottom on _LeadFlowHomeState {
  Widget _buildProcessingBanner() {
    final progress = _total == 0 ? 0.0 : _processed / _total;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(25, 12, 25, 13),
      color: const Color(0xFFEAF5F0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: LeadsColors.forest,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _currentCompany == null
                      ? 'Enriching leads · $_processed of $_total'
                      : 'Enriching $_currentCompany · $_processed of $_total',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: LeadsColors.deepForest,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: const TextStyle(
                  color: LeadsColors.forest,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          LinearProgressIndicator(
            value: progress,
            minHeight: 4,
            borderRadius: BorderRadius.circular(10),
            backgroundColor: const Color(0xFFD3E4DC),
            color: LeadsColors.forest,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    const labels = ['Home', 'Leads', 'Insights', 'Profile'];
    const icons = [
      Icons.home_outlined,
      Icons.person_search_outlined,
      Icons.bar_chart_rounded,
      Icons.person_outline_rounded,
    ];
    return Container(
      height: 83,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: LeadsColors.line)),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            children: [
              for (var i = 0; i < labels.length; i++) ...[
                if (i == 2) const SizedBox(width: 48),
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => _refresh(() => _selectedTab = i),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          icons[i],
                          color: _selectedTab == i ? LeadsColors.forest : LeadsColors.muted,
                          size: 23,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          labels[i],
                          style: TextStyle(
                            color: _selectedTab == i ? LeadsColors.forest : LeadsColors.muted,
                            fontSize: 10,
                            fontWeight: _selectedTab == i
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Transform.translate(
                offset: const Offset(0, -15),
                child: Material(
                  color: LeadsColors.forest,
                  elevation: 7,
                  shadowColor: LeadsColors.forest.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(18),
                  child: InkWell(
                    onTap: _openCampaignSheet,
                    borderRadius: BorderRadius.circular(18),
                    child: const SizedBox(
                      width: 58,
                      height: 60,
                      child: Icon(
                        Icons.add_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


}
