import time
from psycopg2 import OperationalError as Psycopg2Error
from django.db.utils import OperationalError
from django.core.management.base import BaseCommand


class Command(BaseCommand):

    def handle(self, *args, **options):
        self.stdout.write('Waiting for database..')
        for attempt in range(5):
            try:
                self.check(databases=['default'])
                self.stdout.write(self.style.SUCCESS('Database ready !'))
                return
            except (Psycopg2Error, OperationalError):
                if attempt < 4:
                    self.stderr.write('Database unvalaible, plase wait one second..')
                    time.sleep(1)
        self.stderr.write(self.style.ERROR('Database unavalaible after 5 tries. Please retry later.'))
