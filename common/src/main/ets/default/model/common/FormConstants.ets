/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

export class FormConstants {
  public static readonly QUERY_VALID_AGENDA_SQL: string = `
        WITH ResultReminders AS (
        WITH RankedReminders AS (
                SELECT a.form_id,
                       a.image_uri,
                       a.is_hidden,
                       c.album_uri,
                       c.album_name,
                       c.is_show_album_name,
                       ROW_NUMBER() OVER (ORDER BY a.show_time DESC) AS rn_max,
                       ROW_NUMBER() OVER (ORDER BY a.show_time ASC) AS rn_min,
                       MAX(a.show_time) OVER () AS max_show_time
                  FROM Reminders a
                       LEFT JOIN
                       facard c ON a.form_id = c.form_id
                 WHERE a.form_id = ?
            )
            SELECT *
              FROM RankedReminders
             WHERE rn_max = 1 OR
                   (rn_min = (
                                 SELECT MIN(rn_min)
                                   FROM RankedReminders
                                  WHERE is_hidden != 1
                             )
        AND
                    max_show_time < CAST (strftime('%s', datetime('now', 'localtime', '-3 second'), 'UTC') AS INT) )
        )
        SELECT t.*,
               b.photo_blob AS image_data,
               b.photo_bound
          FROM ResultReminders t
               LEFT JOIN
               image_proxy_data b ON t.image_uri = b.uri;
    `;
  public static readonly QUERY_VALID_AGENDA_SQL_WITH_PORTRAIT: string = `
        WITH ResultReminders AS (
        WITH RankedReminders AS (
                SELECT a.form_id,
                       a.image_uri,
                       a.is_hidden,
                       c.album_uri,
                       ROW_NUMBER() OVER (ORDER BY a.show_time DESC) AS rn_max,
                       ROW_NUMBER() OVER (ORDER BY a.show_time ASC) AS rn_min,
                       MAX(a.show_time) OVER () AS max_show_time
                  FROM Reminders a
                       LEFT JOIN
                       facard c ON a.form_id = c.form_id
                 WHERE a.form_id = ?
            )
            SELECT *
              FROM RankedReminders
             WHERE rn_max = 1 OR
                   (rn_min = (
                                 SELECT MIN(rn_min)
                                   FROM RankedReminders
                                  WHERE is_hidden != 1
                             )
        AND
                    max_show_time < CAST (strftime('%s', datetime('now', 'localtime', '-3 second'), 'UTC') AS INT) )
        )
        SELECT t.*,
                b.photo_blob AS image_data,
                b.photo_bound,
                d.is_open AS openState,
                d.cover_uri AS coverUri,
                d.cover_blob AS coverBlob,
                d.cover_uri_id AS coverUriId
        FROM ResultReminders t
            LEFT JOIN
            image_proxy_data b ON t.image_uri = b.uri
            LEFT JOIN
            portrait_form_info d ON d.form_id = t.form_id;
    `;
  public static readonly QUERY_VALID_HIGHLIGHT_AGENDA_SQL: string = `
    WITH ResultReminders AS (
      WITH RankedReminders AS (
          SELECT a.*,
                 ROW_NUMBER() OVER (ORDER BY a.show_time DESC) AS rn_max,
                 ROW_NUMBER() OVER (ORDER BY a.show_time ASC) AS rn_min,
                 MAX(a.show_time) OVER () AS max_show_time
            FROM highlight_reminders a
           WHERE a.form_id = ?
      )
          SELECT *
            FROM RankedReminders
           WHERE rn_max = 1 OR
                 (rn_min = (
                               SELECT MIN(rn_min)
                                 FROM RankedReminders
                                WHERE is_hidden != 1
                           )
                  AND
                 max_show_time < CAST (strftime('%s', datetime('now', 'localtime', '-3 second'), 'UTC') AS INT) )
    )
    SELECT t.*,
           b.photo_blob AS image_data,
           b.photo_bound,
           b.foreground,
           b.wordart
      FROM ResultReminders t
           LEFT JOIN
           highlight_image_proxy_data b ON t.image_uri = b.uri;
    `;
  public static readonly REFRESH_HIGHLIGHT_CARD_SQL: string = `SELECT remindTimer(strftime('%s',
    datetime('now', 'localtime', '+{timeOffset} second'), 'UTC') * 1000) FROM highlight_reminders
    WHERE form_id = ? AND is_hidden = 0 LIMIT 1;`;
  public static readonly UPDATE_HIGHLIGHT_CARD_SQL: string = `UPDATE highlight_reminders
       SET show_time = strftime('%s', datetime('now', 'localtime', 'UTC') )
     WHERE _id IN (
        SELECT _id
          FROM highlight_reminders
         WHERE form_id = ? AND
               CAST (strftime('%s', datetime('now', 'localtime', '-3 second'), 'UTC') AS INT) > (
                   SELECT max(show_time)
                     FROM highlight_reminders
                    WHERE form_id = ?
               )
    AND
               is_hidden = 0
         ORDER BY show_time ASC,
                  _id ASC
         LIMIT 1
    );
  `;

  /* 仅限LightGlimpse使用，记录卡片开启LightGlimpse状态 */
  public static readonly QUERY_VALID_AGENDA_SQL_WITH_LIGHT_GLIMPSE: string = `
        WITH ResultReminders AS (
        WITH RankedReminders AS (
                SELECT a.form_id,
                       a.image_uri,
                       a.is_hidden,
                       c.album_uri,
                       ROW_NUMBER() OVER (ORDER BY a.show_time DESC) AS rn_max,
                       ROW_NUMBER() OVER (ORDER BY a.show_time ASC) AS rn_min,
                       MAX(a.show_time) OVER () AS max_show_time,
                       d.is_open,
                       d.open_time
                  FROM Reminders a
                       LEFT JOIN
                       facard c ON a.form_id = c.form_id
		       LEFT JOIN
                       light_glimpse_status d ON a.form_id = d.form_id
                 WHERE a.form_id = ?
            )
            SELECT *
              FROM RankedReminders
             WHERE rn_max = 1 OR
                   (rn_min = (
                                 SELECT MIN(rn_min)
                                   FROM RankedReminders
                                  WHERE is_hidden != 1
                             )
        AND
                    max_show_time < CAST (strftime('%s', datetime('now', 'localtime', '-3 second'), 'UTC') AS INT) )
        )
        SELECT t.*,
               b.photo_blob AS image_data,
               b.photo_bound
          FROM ResultReminders t
               LEFT JOIN
               image_proxy_data b ON t.image_uri = b.uri;
    `;

  public static readonly POLAROID_WIDGET: string = 'polaroidWidget';
  public static readonly ROLL_FILM_WIDGET: string = 'rollfilmWidget';
  public static readonly UPDATE_SCHEDULER: string = 'updateScheduler';
  public static readonly REFRESH_CARD_SQL: string = `SELECT remindTimer(strftime('%s',
    datetime('now', 'localtime', '+{timeOffset} second'), 'UTC') * 1000) FROM Reminders
    WHERE form_id = ? AND is_hidden = 0 LIMIT 1;`;
  public static readonly UPDATE_CARD_SQL: string = `UPDATE Reminders
       SET show_time = strftime('%s', datetime('now', 'localtime', 'UTC') )
     WHERE _id IN (
        SELECT _id
          FROM Reminders
         WHERE form_id = ? AND
               CAST (strftime('%s', datetime('now', 'localtime', '-3 second'), 'UTC') AS INT) > (
                   SELECT max(show_time)
                     FROM reminders
                    WHERE form_id = ?
               )
    AND
               is_hidden = 0
         ORDER BY show_time ASC,
                  _id ASC
         LIMIT 1
    );
  `;
  public static readonly CLOUD_URI: string = 'datashareproxy://com.ohos.clouddrive/sync_switch' +
    '?bundleName=com.ohos.photos';
  public static readonly DEFAULT_IMAGE: string = `data:image/jpeg;base64,`;
  public static readonly LIMIT_COUNT: number = 120;
  public static readonly SQL_REPLACE_TIME_OFFSET = '{timeOffset}';
  public static readonly SQL_CLEAR_IMAGE_PROXY_DATA = 'DELETE FROM image_proxy_data WHERE uri not in ' +
    '(SELECT image_uri FROM Reminders);'
  public static readonly SQL_CLEAR_REMINDERS = 'DELETE FROM reminders WHERE form_id not in ' +
    '(SELECT form_id FROM facard);'
  public static readonly SQL_CLEAR_PORTRAIT_FORM_INFO = 'DELETE FROM portrait_form_info WHERE form_id not in ' +
    '(SELECT form_id FROM facard);';
  public static readonly SQL_CLEAR_HIGHLIGHT_IMAGE_PROXY_DATA = 'DELETE FROM highlight_image_proxy_data WHERE uri not in ' +
    '(SELECT image_uri FROM highlight_reminders);'
  public static readonly SQL_CLEAR_HIGHLIGHT_REMINDERS = 'DELETE FROM highlight_reminders WHERE form_id not in ' +
    '(SELECT form_id FROM facard);'
  public static readonly DELTA_CLEAR_TIME: number = 1000 * 3600 * 12;
  // 云同步、回收站监听专用注册ID
  public static readonly ALL_FORM_ID: string = '000000';
  public static readonly REMINDER_TABLE_URI: string = 'datashare:///hmos_photodata/reminders';
  public static readonly FACARD_TABLE_URI: string = 'datashare:///hmos_photodata/facard';
  public static readonly HIGHLIGHT_REMINDER_TABLE_URI: string = 'datashare:///hmos_photodata/highlight_reminders';
  public static readonly IMAGE_PROXY_DATA_TABLE_URI: string = 'datashare:///hmos_photodata/image_proxy_data';
  public static readonly PORTRAIT_FORM_INFO_TABLE_URI: string = 'datashare:///hmos_photodata/portrait_form_info';

  // 卡片切换动效执行延迟时间
  public static readonly DELAY_DURATION: number = 500;
  // 卡片切换动效持续时间
  public static readonly ANIMATION_DURATION: number = 500;

  public static readonly ANIMATION_RESET_LIMIT: number = 1100;

  public static readonly DEFAULT_SALIENCY = '0';

  public static readonly DEFAULT_RATIO = '1';

  public static readonly HIGHLIGHT_DEFAULT_FONT: string = 'HarmonyOS-Sans';
}

export class FACardChangeTypesConstants {
  // 图片新增，回收站恢复
  public static readonly IMAGE_ADD_TYPE: number = 0;
  // 图片修改，包括编辑和移入移出
  public static readonly IMAGE_UPDATE_TYPE: number = 1;
  // 图片删除，删除到回收站
  public static readonly IMAGE_DELETE_TYPE: number = 2;
  // 图片隐藏，或者是云同步开关变化
  public static readonly IMAGE_HIDE_OR_CLOUD_TYPE: number = 3;
  // 相册重命名
  public static readonly ALBUM_RENAME: number = 5;
}
