import '../../../../core/network/api_result.dart';
import '../../domain/entities/home_entities.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;

  HomeRepositoryImpl({
    required HomeRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<ApiResult<HomeData>> getHomeData() async {
    try {
      print('🏠 Fetching home data...');
      final response = await _remoteDataSource.getHomeData();
      
      // Convert DTOs to entities
      final specialAdvertisements = response.specialAdvertismentMobileDtos
          .map((dto) => SpecialAdvertisement(
                id: dto.id,
                imageUrl: _buildFullImageUrl(dto.image),
                propertyId: dto.sitePropertyId,
                propertyTitle: dto.sitePropertyTitle,
              ))
          .toList();

      final siteProperties = response.siteProperties
          .map((dto) => Property(
                id: dto.id,
                title: dto.propertyTitle,
                hotelName: dto.hotelName,
                address: dto.address,
                streetAndBuildingNumber: dto.streetAndBuildingNumber,
                landmark: dto.landMark,
                pricePerNight: dto.pricePerNight,
                isActive: dto.isActive,
                isFavorite: dto.isFavorite,
                mainImageUrl: dto.mainImage != null 
                    ? _buildFullImageUrl(dto.mainImage!) 
                    : null,
              ))
          .toList();

      final highlyRatedProperties = response.highlyRatedProperty
          .map((dto) => Property(
                id: dto.id,
                title: dto.propertyTitle,
                hotelName: dto.hotelName,
                address: dto.address,
                streetAndBuildingNumber: dto.streetAndBuildingNumber,
                landmark: dto.landMark,
                pricePerNight: dto.pricePerNight,
                isActive: dto.isActive,
                isFavorite: dto.isFavorite,
                mainImageUrl: dto.mainImage != null 
                    ? _buildFullImageUrl(dto.mainImage!) 
                    : null,
              ))
          .toList();

      final governorates = response.governorateMobileDto
          .map((dto) => Governorate(
                id: dto.id,
                title: dto.title,
              ))
          .toList();

      final onlyForYouSection = OnlyForYouSection(
        id: response.onlyForYouSectionMobileDto.id,
        firstPhotoUrl: _buildFullImageUrl(response.onlyForYouSectionMobileDto.firstPhoto),
        secondPhotoUrl: _buildFullImageUrl(response.onlyForYouSectionMobileDto.secondPhoto),
        thirdPhotoUrl: _buildFullImageUrl(response.onlyForYouSectionMobileDto.thirdPhoto),
      );

      final homeData = HomeData(
        specialAdvertisements: specialAdvertisements,
        siteProperties: siteProperties,
        highlyRatedProperties: highlyRatedProperties,
        governorates: governorates,
        onlyForYouSection: onlyForYouSection,
      );

      print('✅ Home data loaded successfully');
      return ApiResult.success(homeData);
    } catch (error) {
      print('❌ Home data error: $error');
      return ApiResult.failure(error.toString());
    }
  }

  String _buildFullImageUrl(String relativePath) {
    const baseUrl = 'http://srv954186.hstgr.cloud:5000';
    if (relativePath.startsWith('/')) {
      return '$baseUrl$relativePath';
    }
    return '$baseUrl/$relativePath';
  }
}
