Name:		%{project_name}
Version:	%{our_version}
Release:	%{?our_release}%{!?our_release:1}%{?dist}
Summary:	FRED - database structure
Group:		Applications/Utils
License:	GPLv3+
URL:		http://fred.nic.cz
Source0:	%{name}-%{version}.tar.gz
BuildRoot:	%{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
BuildArch:	noarch
Requires:	postgresql-server, postgresql-contrib
BuildRequires:  autoconf, automake, make

%description
FRED (Free Registry for Enum and Domain) is free registry system for 
managing domain registrations. This package contains scripts for 
createing database structure in postgresql database

%prep
%setup -q

%build
autoreconf -vfi
%configure --prefix=/usr

%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
/usr/sbin/fred-dbmanager
/usr/share/fred-db/upgrades/*
/usr/share/fred-db/structure.sql

%changelog

* Sat Jan 19 2007 Jaromir Talir <jaromir.talir@nic.cz>
- Architecture changed to noarch
