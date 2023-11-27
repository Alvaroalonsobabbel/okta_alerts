FROM public.ecr.aws/sam/build-ruby3.2:latest-x86_64

RUN yum install -y amazon-linux-extras \
    && amazon-linux-extras enable postgresql14 \
    && yum group install "Development Tools" -y

RUN yum install -y postgresql postgresql-devel libyaml libtool

ADD Gemfile Gemfile.lock ${LAMBDA_TASK_ROOT}

ENV GEM_HOME=${LAMBDA_TASK_ROOT}
RUN gem update bundler
RUN ARCHFLAGS="-arch x86_64" bundle install --without development test --path $GEM_HOME/vendor/bundle
