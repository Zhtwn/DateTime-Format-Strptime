requires "Carp" => "0";
requires "DateTime" => "1.00";
requires "DateTime::Locale" => "0.45";
requires "DateTime::TimeZone" => "0.79";
requires "Exporter" => "0";
requires "Params::Validate" => "0.64";
requires "strict" => "0";
requires "vars" => "0";

on 'test' => sub {
  requires "ExtUtils::MakeMaker" => "0";
  requires "File::Spec" => "0";
  requires "Test::More" => "0.96";
  requires "utf8" => "0";
  requires "warnings" => "0";
};

on 'test' => sub {
  recommends "CPAN::Meta" => "2.120900";
};

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "0";
};

on 'develop' => sub {
  requires "Code::TidyAll" => "0.24";
  requires "File::Spec" => "0";
  requires "IO::Handle" => "0";
  requires "IPC::Open3" => "0";
  requires "Perl::Critic" => "1.123";
  requires "Perl::Tidy" => "20140711";
  requires "Pod::Coverage::TrustPod" => "0";
  requires "Test::Code::TidyAll" => "0.24";
  requires "Test::EOL" => "0";
  requires "Test::Mojibake" => "0";
  requires "Test::More" => "0.88";
  requires "Test::NoTabs" => "0";
  requires "Test::Pod" => "1.41";
  requires "Test::Pod::Coverage" => "1.08";
  requires "Test::Pod::LinkCheck" => "0";
  requires "Test::Spelling" => "0.12";
  requires "Test::Version" => "1";
};
