# brat docker

This is a docker container deploying an instance of [brat](http://brat.nlplab.org/).


### Installation

The `data/brat-data` directory is be linked to your annotation data, and the `data/config.py` file is linked to the config file.
To add multiple users to the server use `config.py` to list your users and their passwords like so:

```python
USER_PASSWORD = {
  'username': 'password',
}
```

The data in these directories will persist even after stopping or removing the container.
You can then start another brat container as above and you should see the same data. 

### Running

To run the container you need to specify a username, password and email address for BRAT as environment variables when you start the container. These can included in an .env file like so. 

```bash
BRAT_USERNAME=username
BRAT_PASSWORD=password
BRAT_EMAIL=email@email.com
```

This user will have editor permissions.

Then, to start the container, simply run : 

```bash
docker-compose up -d
```