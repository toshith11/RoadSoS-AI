import sys
import os

# Add project root to Python path
ROOT_DIR = os.path.dirname(
    os.path.dirname(
        os.path.abspath(__file__)
    )
)

sys.path.append(ROOT_DIR)

from services.db_service import init_db
from services.db_service import seed_db

print("Creating database tables...")
init_db()

print("Seeding database...")
seed_db()

print("Database setup completed!")