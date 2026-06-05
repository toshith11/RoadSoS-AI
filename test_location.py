from services.hospital_finder import find_nearest_hospital
from services.police_finder import find_nearest_police
from services.firestation_finder import find_nearest_firestation
from services.trauma_finder import find_nearest_trauma_center

lat = 12.9716
lon = 77.5946

print("\nHospital:")
print(find_nearest_hospital(lat, lon))

print("\nPolice:")
print(find_nearest_police(lat, lon))

print("\nFire Station:")
print(find_nearest_firestation(lat, lon))

print("\nTrauma Center:")
print(find_nearest_trauma_center(lat, lon))