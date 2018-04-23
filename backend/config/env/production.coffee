{VERIFY_URL, TOKEN_URL} = process.env

module.exports =
  keepResponseErrors: true
  oauth2:
    url:
      verify: VERIFY_URL
      token: TOKEN_URL
