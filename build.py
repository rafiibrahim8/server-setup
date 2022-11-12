import os
import shutil
from datetime import datetime
from argparse import ArgumentParser

class Build:
    def __init__(self, username, name, swap=0):
        self.__swap = int(swap)
        self.__username = username
        self.__name = name
        with open('src/setup.sh', 'r') as f:
            self.__script = f.read()

    def replace(self, placeholder, value):
        self.__script = self.__script.replace(f'###{placeholder.upper()}###', value)
    
    def build(self):
        print('Building...')
        os.path.exists('dist') and shutil.rmtree('dist')
        os.mkdir('dist')
        self.replace('build_date', datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S'))

        self.replace_packages()
        self.replace_swap()
        self.make_archive()
        self.replace_user()

        with open('dist/setup.sh', 'w') as f:
            f.write(self.__script)
        print('Done!')

    def make_archive(self):
        shutil.make_archive('dist/fs', 'zip', 'fs')

    def replace_packages(self):
        with open('src/packages', 'r') as f:
            packages = [i.strip() for i in f.read().split('\n') if i.strip()]
        packages = list(set(packages))
        packages.sort()
        self.replace('packages', ' '.join(packages))

    def replace_swap(self):
        if self.__swap:
            self.replace('SWAP_SIZE', str(self.__swap))
            self.replace('SWAP_ON', '')
    
    def replace_user(self):
        self.replace('HPU_USER', self.__username)
        self.replace('HPU_NAME', self.__name)


def main():
    parser = ArgumentParser(description='Automate linux server setup')
    parser.add_argument('-u', '--username',required=True, help='username for the high previleged user')
    parser.add_argument('-n', '--name', required=True, help='full name for the high previleged user')
    parser.add_argument('-s', '--swap', default=0, help='swap size in MB. Default is no swap')
    args = parser.parse_args()
    Build(args.username, args.name, args.swap).build()

if __name__ == '__main__':
    main()
