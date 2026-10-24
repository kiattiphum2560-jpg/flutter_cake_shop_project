import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_cake_shop_project/models/cake_shop.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class CakeShopDetail extends StatefulWidget {
  final CakeShop cakeShop;

  const CakeShopDetail({super.key, required this.cakeShop});
  @override
  State<CakeShopDetail> createState() => _CakeShopDetailState();
}

class _CakeShopDetailState extends State<CakeShopDetail> {
  Future<void> _openUrl(
    String url, {
    LaunchMode mode = LaunchMode.externalApplication,
  }) async {
    final uri = Uri.tryParse(url);
    if (uri == null || (!uri.isScheme('http') && !uri.isScheme('https'))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ลิงก์ไม่ถูกต้อง')),
      );
      return;
    }

    final opened = await launchUrl(uri, mode: mode);
    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ไม่สามารถเปิดลิงก์ได้')),
      );
    }
  }

  Future<void> _callPhone() async {
    final phone = widget.cakeShop.phone?.trim();
    if (phone == null || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ไม่พบเบอร์โทรของร้าน')),
      );
      return;
    }

    final uri = Uri(scheme: 'tel', path: phone);
    final opened = await launchUrl(uri);
    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ไม่สามารถเปิดแอปโทรศัพท์ได้')),
      );
    }
  }

  Widget _buildLinkRow({
    required IconData icon,
    required Color iconColor,
    required String url,
    String? label,
    LaunchMode launchMode = LaunchMode.externalApplication,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _openUrl(url, mode: launchMode),
        child: Row(
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label ?? url,
                style: const TextStyle(color: Colors.black87),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.open_in_new, size: 18, color: Colors.black54),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final latitude = double.tryParse(widget.cakeShop.latitude ?? '');
    final longitude = double.tryParse(widget.cakeShop.longitude ?? '');
    final hasCoordinates = latitude != null &&
        longitude != null &&
        latitude >= -90 &&
        latitude <= 90 &&
        longitude >= -180 &&
        longitude <= 180;
    final googleMapsUrl = hasCoordinates
        ? Uri.https('www.google.com', '/maps/search/', {
            'api': '1',
            'query': '$latitude,$longitude',
          }).toString()
        : null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        title: Text(
          widget.cakeShop.name ?? 'รายละเอียดร้านเค้ก',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Center(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    widget.cakeShop.image1 ?? 'assets/images/s11.jpg',
                    width: MediaQuery.sizeOf(context).width * 0.9,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        widget.cakeShop.image2 ??
                            widget.cakeShop.image1 ??
                            'assets/images/s11.jpg',
                        width: MediaQuery.sizeOf(context).width * 0.4,
                      ),
                    ),
                    const SizedBox(width: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        widget.cakeShop.image3 ??
                            widget.cakeShop.image1 ??
                            'assets/images/s11.jpg',
                        width: MediaQuery.sizeOf(context).width * 0.4,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ชื่อร้าน',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.red.shade700,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.cakeShop.name ?? 'ไม่พบชื่อร้าน',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.access_time, color: Colors.red),
                          const SizedBox(width: 8),
                          Text(
                            'เวลาเปิดปิด\n${widget.cakeShop.openCloseTime ?? 'ไม่ระบุเวลาเปิดปิด'}',
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.info_outline, color: Colors.red),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'รายละเอียดของร้าน\n${widget.cakeShop.description ?? 'ไม่มีรายละเอียดร้าน'}',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.location_on, color: Colors.red),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'ที่อยู่ของร้าน\n${widget.cakeShop.address ?? 'ไม่ระบุที่อยู่'}',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _callPhone,
                  icon: const Icon(Icons.phone),
                  label: Text(
                    widget.cakeShop.phone ?? 'ไม่ระบุเบอร์โทร',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.cakeShop.website != null) ...[
                        _buildLinkRow(
                          icon: Icons.language,
                          iconColor: Colors.orange,
                          url: widget.cakeShop.website!,
                        ),
                      ],
                      if (widget.cakeShop.facebook != null) ...[
                        _buildLinkRow(
                          icon: Icons.facebook,
                          iconColor: Colors.blue,
                          url: widget.cakeShop.facebook!,
                          launchMode: LaunchMode.inAppBrowserView,
                        ),
                      ],
                      if (hasCoordinates) ...[
                        const SizedBox(height: 8),
                        _buildLinkRow(
                          icon: Icons.map_outlined,
                          iconColor: Colors.green,
                          url: googleMapsUrl!,
                          label: 'เปิดตำแหน่งใน Google Maps',
                          launchMode: LaunchMode.inAppBrowserView,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                            height: 220,
                            child: FlutterMap(
                              options: MapOptions(
                                initialCenter: LatLng(latitude, longitude),
                                initialZoom: 15,
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  userAgentPackageName:
                                      'flutter_cake_shop_project',
                                ),
                                MarkerLayer(
                                  markers: [
                                    Marker(
                                      point: LatLng(latitude, longitude),
                                      child: const Icon(
                                        Icons.location_pin,
                                        color: Colors.red,
                                        size: 40,
                                      ),
                                    ),
                                  ],
                                ),
                                RichAttributionWidget(
                                  attributions: [
                                    TextSourceAttribution(
                                      'OpenStreetMap contributors',
                                      onTap: () => _openUrl(
                                        'https://www.openstreetmap.org/copyright',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
