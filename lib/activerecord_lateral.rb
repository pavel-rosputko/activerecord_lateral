module ActiveRecordLateral
  module CollectionAssociationExt
    def build_scope
      super.order(preload_scope.values[:order] || reflection_scope.values[:order]).
        limit(preload_scope.values[:limit] || reflection_scope.values[:limit])
    end

    def records_for(ids)
      if preload_scope.values[:limit] || reflection_scope.values[:limit]

        relation = scope.where(association_key.eq(Arel.sql('ids.id')))

        # TODO escape or VALUES
        klass.unscoped.
          from("(SELECT unnest(ARRAY[#{ids.join(' ,')}]) id) ids, LATERAL (#{relation.to_sql}) #{klass.table_name}")
      else
        scope.where(association_key.in(ids))
      end
    end
  end
end

ActiveRecord::Associations::Preloader::CollectionAssociation.class_eval do
  include ActiveRecordLateral::CollectionAssociationExt
end
