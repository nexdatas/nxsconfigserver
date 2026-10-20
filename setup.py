#!/usr/bin/env python
#   This file is part of nexdatas - Tango Server for NeXus data writer
#
#    Copyright (C) 2012-2017 DESY, Jan Kotanski <jkotan@mail.desy.de>
#
#    nexdatas is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    nexdatas is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with nexdatas.  If not, see <http://www.gnu.org/licenses/>.
#
#

""" setup.py for NXS configuration server """

import os
import sys
from setuptools import setup
from importlib.util import module_from_spec, spec_from_file_location
from pathlib import Path

try:
    from sphinx.setup_command import BuildDoc
except Exception:
    BuildDoc = None


# __requires__ = 'nextdata ==%s' % INXS.__version__
needs_pytest = set(['test']).intersection(sys.argv)
pytest_runner = ['pytest-runner'] if needs_pytest else []


def get_version():
    path = Path(__file__).parent / "nxsconfigserver" / "Release.py"
    spec = spec_from_file_location("Release", path.as_posix())
    module = module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def read(fname):
    """ read the file

    :param fname: readme file name
    """
    return open(os.path.join(os.path.dirname(__file__), fname)).read()


release = get_version().__version__
version = ".".join(release.split(".")[:2])
name = "NXSConfigServer"


#: required files
REQUIRED = [
    'numpy (>=1.5.0)',
    'PyTango (>=7.2.2)',
    #    'libpninx (>=0.1.2)'
    #   'pninx-python (>=0.1.2)'
    #   'libpninx-python (>=0.1.2)'
    #   'libpninx-python (>=0.1.2)'
]

#: required python packages
install_requires = [
    'lxml',
    # 'nxstools',
    # 'pymysqldb',
    # 'pytango',
]

#: metadata for distutils
SETUPDATA = dict(
    name="nxsconfigserver",
    version=release,
    author="Jan Kotanski, Eugen Wintersberger , Halil Pasic",
    author_email="jankotan@gmail.com, eugen.wintersberger@gmail.com, "
    "halil.pasic@gmail.com",
    description=("Configuration Server for Nexus Data Writer"),
    license="GNU GENERAL PUBLIC LICENSE v3",
    keywords="configuration MySQL writer Tango server nexus data",
    url="http://github.com/jkotan/nexdatas/nxsconfigserver",
    packages=['nxsconfigserver'],
    classifiers=[
        'Development Status :: 5 - Production/Stable',
        'Intended Audience :: Science/Research',
        'Topic :: Scientific/Engineering :: Physics',
        'Topic :: Software Development :: Libraries :: Python Modules',
        'License :: OSI Approved :: GNU General Public License v3 (GPLv3)',
        'Programming Language :: Python :: 2.7',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.4',
        'Programming Language :: Python :: 3.5',
        'Programming Language :: Python :: 3.6',
        'Programming Language :: Python :: 3.7',
        'Programming Language :: Python :: 3.8',
        'Programming Language :: Python :: 3.9',
        'Programming Language :: Python :: 3.10',
        'Programming Language :: Python :: 3.11',
        'Programming Language :: Python :: 3.12',
        'Programming Language :: Python :: 3.13',
        'Programming Language :: Python :: 3.14',
    ],
    install_requires=install_requires,
    entry_points={
        'console_scripts':
        'NXSConfigServer = nxsconfigserver:main'},
    # scripts=['NXSConfigServer'],
    cmdclass={
        'build_sphinx': BuildDoc
    },
    zip_safe=False,
    setup_requires=pytest_runner,
    tests_require=['pytest'],
    command_options={
        'build_sphinx': {
            'project': ('setup.py', name),
            'version': ('setup.py', version),
            'release': ('setup.py', release)}},
    long_description=read('README.rst')
    # long_description_content_type='text/x-rst'
)


def main():
    """ the main function """
    setup(**SETUPDATA)


if __name__ == '__main__':
    main()
