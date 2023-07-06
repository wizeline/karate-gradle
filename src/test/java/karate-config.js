function fn() {
    var env = karate.env; // get java system property 'karate.env'
    karate.log('karate.env system property was:', env);
    var envFile = read('classpath:env_data.json')

    if (!env) {
        env = 'dev';
    }

    var config = {
        projects: '/projects',
        tasks: '/tasks'
    }

    if (env == 'dev') {
        config.token = 'Bearer ' + envFile[env].token
        config.baseURL = 'https://api.todoist.com/rest/v2'
    }

    karate.configure('connectTimeout', 30000);
    karate.configure('readTimeout', 30000);
    karate.configure('headers', { Authorization: config.token });
    return config;
}
