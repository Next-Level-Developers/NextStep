// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ConversationCareerBrief _$ConversationCareerBriefFromJson(
    Map<String, dynamic> json) {
  return _ConversationCareerBrief.fromJson(json);
}

/// @nodoc
mixin _$ConversationCareerBrief {
  String get slug => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ConversationCareerBriefCopyWith<ConversationCareerBrief> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationCareerBriefCopyWith<$Res> {
  factory $ConversationCareerBriefCopyWith(ConversationCareerBrief value,
          $Res Function(ConversationCareerBrief) then) =
      _$ConversationCareerBriefCopyWithImpl<$Res, ConversationCareerBrief>;
  @useResult
  $Res call({String slug, String name});
}

/// @nodoc
class _$ConversationCareerBriefCopyWithImpl<$Res,
        $Val extends ConversationCareerBrief>
    implements $ConversationCareerBriefCopyWith<$Res> {
  _$ConversationCareerBriefCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? slug = null,
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConversationCareerBriefImplCopyWith<$Res>
    implements $ConversationCareerBriefCopyWith<$Res> {
  factory _$$ConversationCareerBriefImplCopyWith(
          _$ConversationCareerBriefImpl value,
          $Res Function(_$ConversationCareerBriefImpl) then) =
      __$$ConversationCareerBriefImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String slug, String name});
}

/// @nodoc
class __$$ConversationCareerBriefImplCopyWithImpl<$Res>
    extends _$ConversationCareerBriefCopyWithImpl<$Res,
        _$ConversationCareerBriefImpl>
    implements _$$ConversationCareerBriefImplCopyWith<$Res> {
  __$$ConversationCareerBriefImplCopyWithImpl(
      _$ConversationCareerBriefImpl _value,
      $Res Function(_$ConversationCareerBriefImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? slug = null,
    Object? name = null,
  }) {
    return _then(_$ConversationCareerBriefImpl(
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConversationCareerBriefImpl implements _ConversationCareerBrief {
  const _$ConversationCareerBriefImpl({required this.slug, required this.name});

  factory _$ConversationCareerBriefImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConversationCareerBriefImplFromJson(json);

  @override
  final String slug;
  @override
  final String name;

  @override
  String toString() {
    return 'ConversationCareerBrief(slug: $slug, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationCareerBriefImpl &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, slug, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationCareerBriefImplCopyWith<_$ConversationCareerBriefImpl>
      get copyWith => __$$ConversationCareerBriefImplCopyWithImpl<
          _$ConversationCareerBriefImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConversationCareerBriefImplToJson(
      this,
    );
  }
}

abstract class _ConversationCareerBrief implements ConversationCareerBrief {
  const factory _ConversationCareerBrief(
      {required final String slug,
      required final String name}) = _$ConversationCareerBriefImpl;

  factory _ConversationCareerBrief.fromJson(Map<String, dynamic> json) =
      _$ConversationCareerBriefImpl.fromJson;

  @override
  String get slug;
  @override
  String get name;
  @override
  @JsonKey(ignore: true)
  _$$ConversationCareerBriefImplCopyWith<_$ConversationCareerBriefImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) {
  return _ChatMessage.fromJson(json);
}

/// @nodoc
mixin _$ChatMessage {
  String get id => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  @JsonKey(name: 'tokens_used')
  int? get tokensUsed => throw _privateConstructorUsedError;
  @JsonKey(name: 'model_version')
  String? get modelVersion => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChatMessageCopyWith<ChatMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatMessageCopyWith<$Res> {
  factory $ChatMessageCopyWith(
          ChatMessage value, $Res Function(ChatMessage) then) =
      _$ChatMessageCopyWithImpl<$Res, ChatMessage>;
  @useResult
  $Res call(
      {String id,
      String role,
      String content,
      @JsonKey(name: 'tokens_used') int? tokensUsed,
      @JsonKey(name: 'model_version') String? modelVersion,
      @JsonKey(name: 'created_at') String? createdAt});
}

/// @nodoc
class _$ChatMessageCopyWithImpl<$Res, $Val extends ChatMessage>
    implements $ChatMessageCopyWith<$Res> {
  _$ChatMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? role = null,
    Object? content = null,
    Object? tokensUsed = freezed,
    Object? modelVersion = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      tokensUsed: freezed == tokensUsed
          ? _value.tokensUsed
          : tokensUsed // ignore: cast_nullable_to_non_nullable
              as int?,
      modelVersion: freezed == modelVersion
          ? _value.modelVersion
          : modelVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChatMessageImplCopyWith<$Res>
    implements $ChatMessageCopyWith<$Res> {
  factory _$$ChatMessageImplCopyWith(
          _$ChatMessageImpl value, $Res Function(_$ChatMessageImpl) then) =
      __$$ChatMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String role,
      String content,
      @JsonKey(name: 'tokens_used') int? tokensUsed,
      @JsonKey(name: 'model_version') String? modelVersion,
      @JsonKey(name: 'created_at') String? createdAt});
}

/// @nodoc
class __$$ChatMessageImplCopyWithImpl<$Res>
    extends _$ChatMessageCopyWithImpl<$Res, _$ChatMessageImpl>
    implements _$$ChatMessageImplCopyWith<$Res> {
  __$$ChatMessageImplCopyWithImpl(
      _$ChatMessageImpl _value, $Res Function(_$ChatMessageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? role = null,
    Object? content = null,
    Object? tokensUsed = freezed,
    Object? modelVersion = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$ChatMessageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      tokensUsed: freezed == tokensUsed
          ? _value.tokensUsed
          : tokensUsed // ignore: cast_nullable_to_non_nullable
              as int?,
      modelVersion: freezed == modelVersion
          ? _value.modelVersion
          : modelVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatMessageImpl implements _ChatMessage {
  const _$ChatMessageImpl(
      {required this.id,
      required this.role,
      required this.content,
      @JsonKey(name: 'tokens_used') this.tokensUsed,
      @JsonKey(name: 'model_version') this.modelVersion,
      @JsonKey(name: 'created_at') this.createdAt});

  factory _$ChatMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatMessageImplFromJson(json);

  @override
  final String id;
  @override
  final String role;
  @override
  final String content;
  @override
  @JsonKey(name: 'tokens_used')
  final int? tokensUsed;
  @override
  @JsonKey(name: 'model_version')
  final String? modelVersion;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;

  @override
  String toString() {
    return 'ChatMessage(id: $id, role: $role, content: $content, tokensUsed: $tokensUsed, modelVersion: $modelVersion, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatMessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.tokensUsed, tokensUsed) ||
                other.tokensUsed == tokensUsed) &&
            (identical(other.modelVersion, modelVersion) ||
                other.modelVersion == modelVersion) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, role, content, tokensUsed, modelVersion, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatMessageImplCopyWith<_$ChatMessageImpl> get copyWith =>
      __$$ChatMessageImplCopyWithImpl<_$ChatMessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatMessageImplToJson(
      this,
    );
  }
}

abstract class _ChatMessage implements ChatMessage {
  const factory _ChatMessage(
          {required final String id,
          required final String role,
          required final String content,
          @JsonKey(name: 'tokens_used') final int? tokensUsed,
          @JsonKey(name: 'model_version') final String? modelVersion,
          @JsonKey(name: 'created_at') final String? createdAt}) =
      _$ChatMessageImpl;

  factory _ChatMessage.fromJson(Map<String, dynamic> json) =
      _$ChatMessageImpl.fromJson;

  @override
  String get id;
  @override
  String get role;
  @override
  String get content;
  @override
  @JsonKey(name: 'tokens_used')
  int? get tokensUsed;
  @override
  @JsonKey(name: 'model_version')
  String? get modelVersion;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$ChatMessageImplCopyWith<_$ChatMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ConversationListItem _$ConversationListItemFromJson(Map<String, dynamic> json) {
  return _ConversationListItem.fromJson(json);
}

/// @nodoc
mixin _$ConversationListItem {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'conversation_type')
  String? get conversationType => throw _privateConstructorUsedError;
  ConversationCareerBrief? get career => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'message_count')
  int get messageCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_message_at')
  String? get lastMessageAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ConversationListItemCopyWith<ConversationListItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationListItemCopyWith<$Res> {
  factory $ConversationListItemCopyWith(ConversationListItem value,
          $Res Function(ConversationListItem) then) =
      _$ConversationListItemCopyWithImpl<$Res, ConversationListItem>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'conversation_type') String? conversationType,
      ConversationCareerBrief? career,
      String? title,
      @JsonKey(name: 'message_count') int messageCount,
      @JsonKey(name: 'last_message_at') String? lastMessageAt,
      @JsonKey(name: 'is_active') bool isActive});

  $ConversationCareerBriefCopyWith<$Res>? get career;
}

/// @nodoc
class _$ConversationListItemCopyWithImpl<$Res,
        $Val extends ConversationListItem>
    implements $ConversationListItemCopyWith<$Res> {
  _$ConversationListItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conversationType = freezed,
    Object? career = freezed,
    Object? title = freezed,
    Object? messageCount = null,
    Object? lastMessageAt = freezed,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      conversationType: freezed == conversationType
          ? _value.conversationType
          : conversationType // ignore: cast_nullable_to_non_nullable
              as String?,
      career: freezed == career
          ? _value.career
          : career // ignore: cast_nullable_to_non_nullable
              as ConversationCareerBrief?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      messageCount: null == messageCount
          ? _value.messageCount
          : messageCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastMessageAt: freezed == lastMessageAt
          ? _value.lastMessageAt
          : lastMessageAt // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ConversationCareerBriefCopyWith<$Res>? get career {
    if (_value.career == null) {
      return null;
    }

    return $ConversationCareerBriefCopyWith<$Res>(_value.career!, (value) {
      return _then(_value.copyWith(career: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ConversationListItemImplCopyWith<$Res>
    implements $ConversationListItemCopyWith<$Res> {
  factory _$$ConversationListItemImplCopyWith(_$ConversationListItemImpl value,
          $Res Function(_$ConversationListItemImpl) then) =
      __$$ConversationListItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'conversation_type') String? conversationType,
      ConversationCareerBrief? career,
      String? title,
      @JsonKey(name: 'message_count') int messageCount,
      @JsonKey(name: 'last_message_at') String? lastMessageAt,
      @JsonKey(name: 'is_active') bool isActive});

  @override
  $ConversationCareerBriefCopyWith<$Res>? get career;
}

/// @nodoc
class __$$ConversationListItemImplCopyWithImpl<$Res>
    extends _$ConversationListItemCopyWithImpl<$Res, _$ConversationListItemImpl>
    implements _$$ConversationListItemImplCopyWith<$Res> {
  __$$ConversationListItemImplCopyWithImpl(_$ConversationListItemImpl _value,
      $Res Function(_$ConversationListItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conversationType = freezed,
    Object? career = freezed,
    Object? title = freezed,
    Object? messageCount = null,
    Object? lastMessageAt = freezed,
    Object? isActive = null,
  }) {
    return _then(_$ConversationListItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      conversationType: freezed == conversationType
          ? _value.conversationType
          : conversationType // ignore: cast_nullable_to_non_nullable
              as String?,
      career: freezed == career
          ? _value.career
          : career // ignore: cast_nullable_to_non_nullable
              as ConversationCareerBrief?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      messageCount: null == messageCount
          ? _value.messageCount
          : messageCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastMessageAt: freezed == lastMessageAt
          ? _value.lastMessageAt
          : lastMessageAt // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConversationListItemImpl implements _ConversationListItem {
  const _$ConversationListItemImpl(
      {required this.id,
      @JsonKey(name: 'conversation_type') this.conversationType,
      this.career,
      this.title,
      @JsonKey(name: 'message_count') this.messageCount = 0,
      @JsonKey(name: 'last_message_at') this.lastMessageAt,
      @JsonKey(name: 'is_active') this.isActive = true});

  factory _$ConversationListItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConversationListItemImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'conversation_type')
  final String? conversationType;
  @override
  final ConversationCareerBrief? career;
  @override
  final String? title;
  @override
  @JsonKey(name: 'message_count')
  final int messageCount;
  @override
  @JsonKey(name: 'last_message_at')
  final String? lastMessageAt;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;

  @override
  String toString() {
    return 'ConversationListItem(id: $id, conversationType: $conversationType, career: $career, title: $title, messageCount: $messageCount, lastMessageAt: $lastMessageAt, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationListItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.conversationType, conversationType) ||
                other.conversationType == conversationType) &&
            (identical(other.career, career) || other.career == career) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.messageCount, messageCount) ||
                other.messageCount == messageCount) &&
            (identical(other.lastMessageAt, lastMessageAt) ||
                other.lastMessageAt == lastMessageAt) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, conversationType, career,
      title, messageCount, lastMessageAt, isActive);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationListItemImplCopyWith<_$ConversationListItemImpl>
      get copyWith =>
          __$$ConversationListItemImplCopyWithImpl<_$ConversationListItemImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConversationListItemImplToJson(
      this,
    );
  }
}

abstract class _ConversationListItem implements ConversationListItem {
  const factory _ConversationListItem(
          {required final String id,
          @JsonKey(name: 'conversation_type') final String? conversationType,
          final ConversationCareerBrief? career,
          final String? title,
          @JsonKey(name: 'message_count') final int messageCount,
          @JsonKey(name: 'last_message_at') final String? lastMessageAt,
          @JsonKey(name: 'is_active') final bool isActive}) =
      _$ConversationListItemImpl;

  factory _ConversationListItem.fromJson(Map<String, dynamic> json) =
      _$ConversationListItemImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'conversation_type')
  String? get conversationType;
  @override
  ConversationCareerBrief? get career;
  @override
  String? get title;
  @override
  @JsonKey(name: 'message_count')
  int get messageCount;
  @override
  @JsonKey(name: 'last_message_at')
  String? get lastMessageAt;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(ignore: true)
  _$$ConversationListItemImplCopyWith<_$ConversationListItemImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ConversationDetail _$ConversationDetailFromJson(Map<String, dynamic> json) {
  return _ConversationDetail.fromJson(json);
}

/// @nodoc
mixin _$ConversationDetail {
  @JsonKey(name: 'conversation_id')
  String get conversationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'conversation_type')
  String? get conversationType => throw _privateConstructorUsedError;
  ConversationCareerBrief? get career => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'message_count')
  int get messageCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'started_at')
  String? get startedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_message_at')
  String? get lastMessageAt => throw _privateConstructorUsedError;
  List<ChatMessage> get messages => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ConversationDetailCopyWith<ConversationDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationDetailCopyWith<$Res> {
  factory $ConversationDetailCopyWith(
          ConversationDetail value, $Res Function(ConversationDetail) then) =
      _$ConversationDetailCopyWithImpl<$Res, ConversationDetail>;
  @useResult
  $Res call(
      {@JsonKey(name: 'conversation_id') String conversationId,
      @JsonKey(name: 'conversation_type') String? conversationType,
      ConversationCareerBrief? career,
      String? title,
      @JsonKey(name: 'message_count') int messageCount,
      @JsonKey(name: 'started_at') String? startedAt,
      @JsonKey(name: 'last_message_at') String? lastMessageAt,
      List<ChatMessage> messages});

  $ConversationCareerBriefCopyWith<$Res>? get career;
}

/// @nodoc
class _$ConversationDetailCopyWithImpl<$Res, $Val extends ConversationDetail>
    implements $ConversationDetailCopyWith<$Res> {
  _$ConversationDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? conversationId = null,
    Object? conversationType = freezed,
    Object? career = freezed,
    Object? title = freezed,
    Object? messageCount = null,
    Object? startedAt = freezed,
    Object? lastMessageAt = freezed,
    Object? messages = null,
  }) {
    return _then(_value.copyWith(
      conversationId: null == conversationId
          ? _value.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as String,
      conversationType: freezed == conversationType
          ? _value.conversationType
          : conversationType // ignore: cast_nullable_to_non_nullable
              as String?,
      career: freezed == career
          ? _value.career
          : career // ignore: cast_nullable_to_non_nullable
              as ConversationCareerBrief?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      messageCount: null == messageCount
          ? _value.messageCount
          : messageCount // ignore: cast_nullable_to_non_nullable
              as int,
      startedAt: freezed == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageAt: freezed == lastMessageAt
          ? _value.lastMessageAt
          : lastMessageAt // ignore: cast_nullable_to_non_nullable
              as String?,
      messages: null == messages
          ? _value.messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<ChatMessage>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ConversationCareerBriefCopyWith<$Res>? get career {
    if (_value.career == null) {
      return null;
    }

    return $ConversationCareerBriefCopyWith<$Res>(_value.career!, (value) {
      return _then(_value.copyWith(career: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ConversationDetailImplCopyWith<$Res>
    implements $ConversationDetailCopyWith<$Res> {
  factory _$$ConversationDetailImplCopyWith(_$ConversationDetailImpl value,
          $Res Function(_$ConversationDetailImpl) then) =
      __$$ConversationDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'conversation_id') String conversationId,
      @JsonKey(name: 'conversation_type') String? conversationType,
      ConversationCareerBrief? career,
      String? title,
      @JsonKey(name: 'message_count') int messageCount,
      @JsonKey(name: 'started_at') String? startedAt,
      @JsonKey(name: 'last_message_at') String? lastMessageAt,
      List<ChatMessage> messages});

  @override
  $ConversationCareerBriefCopyWith<$Res>? get career;
}

/// @nodoc
class __$$ConversationDetailImplCopyWithImpl<$Res>
    extends _$ConversationDetailCopyWithImpl<$Res, _$ConversationDetailImpl>
    implements _$$ConversationDetailImplCopyWith<$Res> {
  __$$ConversationDetailImplCopyWithImpl(_$ConversationDetailImpl _value,
      $Res Function(_$ConversationDetailImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? conversationId = null,
    Object? conversationType = freezed,
    Object? career = freezed,
    Object? title = freezed,
    Object? messageCount = null,
    Object? startedAt = freezed,
    Object? lastMessageAt = freezed,
    Object? messages = null,
  }) {
    return _then(_$ConversationDetailImpl(
      conversationId: null == conversationId
          ? _value.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as String,
      conversationType: freezed == conversationType
          ? _value.conversationType
          : conversationType // ignore: cast_nullable_to_non_nullable
              as String?,
      career: freezed == career
          ? _value.career
          : career // ignore: cast_nullable_to_non_nullable
              as ConversationCareerBrief?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      messageCount: null == messageCount
          ? _value.messageCount
          : messageCount // ignore: cast_nullable_to_non_nullable
              as int,
      startedAt: freezed == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageAt: freezed == lastMessageAt
          ? _value.lastMessageAt
          : lastMessageAt // ignore: cast_nullable_to_non_nullable
              as String?,
      messages: null == messages
          ? _value._messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<ChatMessage>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConversationDetailImpl implements _ConversationDetail {
  const _$ConversationDetailImpl(
      {@JsonKey(name: 'conversation_id') required this.conversationId,
      @JsonKey(name: 'conversation_type') this.conversationType,
      this.career,
      this.title,
      @JsonKey(name: 'message_count') this.messageCount = 0,
      @JsonKey(name: 'started_at') this.startedAt,
      @JsonKey(name: 'last_message_at') this.lastMessageAt,
      final List<ChatMessage> messages = const []})
      : _messages = messages;

  factory _$ConversationDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConversationDetailImplFromJson(json);

  @override
  @JsonKey(name: 'conversation_id')
  final String conversationId;
  @override
  @JsonKey(name: 'conversation_type')
  final String? conversationType;
  @override
  final ConversationCareerBrief? career;
  @override
  final String? title;
  @override
  @JsonKey(name: 'message_count')
  final int messageCount;
  @override
  @JsonKey(name: 'started_at')
  final String? startedAt;
  @override
  @JsonKey(name: 'last_message_at')
  final String? lastMessageAt;
  final List<ChatMessage> _messages;
  @override
  @JsonKey()
  List<ChatMessage> get messages {
    if (_messages is EqualUnmodifiableListView) return _messages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_messages);
  }

  @override
  String toString() {
    return 'ConversationDetail(conversationId: $conversationId, conversationType: $conversationType, career: $career, title: $title, messageCount: $messageCount, startedAt: $startedAt, lastMessageAt: $lastMessageAt, messages: $messages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationDetailImpl &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            (identical(other.conversationType, conversationType) ||
                other.conversationType == conversationType) &&
            (identical(other.career, career) || other.career == career) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.messageCount, messageCount) ||
                other.messageCount == messageCount) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.lastMessageAt, lastMessageAt) ||
                other.lastMessageAt == lastMessageAt) &&
            const DeepCollectionEquality().equals(other._messages, _messages));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      conversationId,
      conversationType,
      career,
      title,
      messageCount,
      startedAt,
      lastMessageAt,
      const DeepCollectionEquality().hash(_messages));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationDetailImplCopyWith<_$ConversationDetailImpl> get copyWith =>
      __$$ConversationDetailImplCopyWithImpl<_$ConversationDetailImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConversationDetailImplToJson(
      this,
    );
  }
}

abstract class _ConversationDetail implements ConversationDetail {
  const factory _ConversationDetail(
      {@JsonKey(name: 'conversation_id') required final String conversationId,
      @JsonKey(name: 'conversation_type') final String? conversationType,
      final ConversationCareerBrief? career,
      final String? title,
      @JsonKey(name: 'message_count') final int messageCount,
      @JsonKey(name: 'started_at') final String? startedAt,
      @JsonKey(name: 'last_message_at') final String? lastMessageAt,
      final List<ChatMessage> messages}) = _$ConversationDetailImpl;

  factory _ConversationDetail.fromJson(Map<String, dynamic> json) =
      _$ConversationDetailImpl.fromJson;

  @override
  @JsonKey(name: 'conversation_id')
  String get conversationId;
  @override
  @JsonKey(name: 'conversation_type')
  String? get conversationType;
  @override
  ConversationCareerBrief? get career;
  @override
  String? get title;
  @override
  @JsonKey(name: 'message_count')
  int get messageCount;
  @override
  @JsonKey(name: 'started_at')
  String? get startedAt;
  @override
  @JsonKey(name: 'last_message_at')
  String? get lastMessageAt;
  @override
  List<ChatMessage> get messages;
  @override
  @JsonKey(ignore: true)
  _$$ConversationDetailImplCopyWith<_$ConversationDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
