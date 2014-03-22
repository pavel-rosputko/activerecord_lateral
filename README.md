activerecord_lateral
====================

Let's imagine

```ruby
class Discussion < ActiveRecord::Base
  belongs_to :topic
end

class Topic < ActiveRecord::Base
  has_many :discussions
  has_many :last_discussions, -> { order(created_at: :desc).limit(3) }, class_name: Discussions
end
```
    
`Topic.all.includes(:last_discussions)` works!

Internals
=========
```sql
SELECT "discussions".* FROM (SELECT unnest(ARRAY[2 ,1]) id) ids, LATERAL (SELECT "discussions".* FROM "discussions" WHERE "discussions"."topic_id" = ids.id ORDER BY "discussions"."created_at" DESC LIMIT 3) discussions
```

    
    
    
    
