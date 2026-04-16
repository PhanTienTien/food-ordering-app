package com.tientien.foodapp.common.utils;

public class LocationUtils {

    private static final double EARTH_RADIUS_KM = 6371.0;

    /**
     * Calculate distance between two coordinates using Haversine formula
     * @param lat1 Latitude of point 1
     * @param lon1 Longitude of point 1
     * @param lat2 Latitude of point 2
     * @param lon2 Longitude of point 2
     * @return Distance in kilometers
     */
    public static double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
        double latDistance = Math.toRadians(lat2 - lat1);
        double lonDistance = Math.toRadians(lon2 - lon1);

        double a = Math.sin(latDistance / 2) * Math.sin(latDistance / 2)
                + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
                * Math.sin(lonDistance / 2) * Math.sin(lonDistance / 2);

        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

        return EARTH_RADIUS_KM * c;
    }

    /**
     * Calculate shipping fee based on distance
     * Base fee: 15,000 VND
     * Additional: 5,000 VND per km after 3km
     * @param distanceKm Distance in kilometers
     * @return Shipping fee in VND
     */
    public static double calculateShippingFee(double distanceKm) {
        double baseFee = 15000;
        double freeDistanceKm = 3.0;
        double additionalFeePerKm = 5000;

        if (distanceKm <= freeDistanceKm) {
            return baseFee;
        }

        double additionalDistance = distanceKm - freeDistanceKm;
        double additionalFee = additionalDistance * additionalFeePerKm;

        return baseFee + additionalFee;
    }
}
