module.exports =
  tags: (req, res) ->
    sails.models.portfolio
      .find createdBy: req.user.email
      .then (items) ->
        ret = []
        for i in items
          for tag in i.tags
            if tag not in ret
              ret.push tag
        res.ok ret
      .catch res.negotiate
